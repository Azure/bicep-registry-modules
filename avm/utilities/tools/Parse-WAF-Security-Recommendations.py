import requests
import yaml
import csv
import markdown
from bs4 import BeautifulSoup
import re
import time

def parse_toc(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        content = response.text
        toc = yaml.safe_load(content)

        def find_recommendations(items):
            results = []
            for item in items:
                if 'items' in item:
                    results.extend(find_recommendations(item['items']))
                elif 'href' in item and item['href'].startswith('recommendations-reference'):
                    results.append(item)
            return results

        recommendations = find_recommendations(toc)
        print(f"Found {len(recommendations)} recommendation items in TOC")
        return recommendations
    except Exception as e:
        print(f"Error parsing TOC: {str(e)}")
        return []

def parse_recommendation_page(url):
    try:
        print(f"Fetching page: {url}")
        response = requests.get(url)
        response.raise_for_status()
        content = response.text
        
        # Convert Markdown to HTML
        html_content = markdown.markdown(content)
        
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # Find all h2 tags that contain "Azure"
        azure_h2_tags = [h2 for h2 in soup.find_all('h2') if 'Azure' in h2.text]
        
        if not azure_h2_tags:
            print("No h2 tag with 'Azure' found")
            return None

        recommendations = []
        
        for h2 in azure_h2_tags:
            name = h2.text.strip()
            print(f"Found name: {name}")
            
            # Find all h3 tags that follow this h2 until the next h2
            h3_tags = []
            next_element = h2.next_sibling
            while next_element and next_element.name != 'h2':
                if next_element.name == 'h3':
                    h3_tags.append(next_element)
                next_element = next_element.next_sibling
            
            for h3 in h3_tags:
                description = h3.text.strip()
                print(f"Found description: {description}")
                
                # Find the next sibling elements until the next h3 or h2
                next_element = h3.next_sibling
                policy_url = ''
                severity = ''
                type_info = ''
                additional_info = []
                
                while next_element and next_element.name not in ['h3', 'h2']:
                    if isinstance(next_element, str):
                        text = next_element.strip()
                        if text:
                            additional_info.append(text)
                    elif next_element.name in ['p', 'li']:
                        text = next_element.text.strip()
                        if text:
                            additional_info.append(text)
                    
                    next_element = next_element.next_sibling
                
                # Join additional info and search for severity, type, and policy URL
                additional_text = ' '.join(additional_info)
                
                severity_match = re.search(r'Severity:\s*(\w+)', additional_text)
                if severity_match:
                    severity = severity_match.group(1)
                    print(f"Found severity: {severity}")
                
                type_match = re.search(r'Type:\s*(.+?)(?=\n|$)', additional_text)
                if type_match:
                    type_info = type_match.group(1).strip()
                    print(f"Found type: {type_info}")
                
                # Extract policy URL
                policy_match = re.search(r'Related policy: \[.+?\]\((https://portal\.azure\.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/[^)]+)\)', additional_text)
                if policy_match:
                    policy_url = policy_match.group(1)
                    print(f"Found policy URL: {policy_url}")
                
                recommendations.append({
                    'name': name,
                    'description': description,
                    'policy_url': policy_url,
                    'severity': severity,
                    'type': type_info
                })
        
        return recommendations
    except Exception as e:
        print(f"Error parsing page {url}: {str(e)}")
        return None

# URL of the TOC.yml file
toc_url = "https://raw.githubusercontent.com/MicrosoftDocs/azure-security-docs/refs/heads/main/articles/defender-for-cloud/TOC.yml"

# Parse the TOC and get recommendations
recommendation_items = parse_toc(toc_url)

if not recommendation_items:
    print("No recommendation items found. Exiting.")
    exit()

# Prepare CSV file
csv_filename = 'recommendations.csv'
csv_headers = ['Name', 'Description', 'Policy URL', 'Severity', 'Type']

with open(csv_filename, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=csv_headers)
    writer.writeheader()

    for item in recommendation_items:
        page_url = f"https://raw.githubusercontent.com/MicrosoftDocs/azure-security-docs/refs/heads/main/articles/defender-for-cloud/{item['href']}"
        page_data = parse_recommendation_page(page_url)
        
        if page_data:
            for recommendation in page_data:
                writer.writerow({
                    'Name': recommendation['name'],
                    'Description': recommendation['description'],
                    'Policy URL': recommendation['policy_url'],
                    'Severity': recommendation['severity'],
                    'Type': recommendation['type']
                })
                print(f"Processed and wrote to CSV: {recommendation['description']}")
        else:
            print(f"Failed to process: {item['name']}")
        
        time.sleep(1)

print(f"CSV file '{csv_filename}' has been created with the extracted information.")
