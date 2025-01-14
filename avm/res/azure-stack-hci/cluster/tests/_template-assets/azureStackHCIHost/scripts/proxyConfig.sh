#!/bin/sh

sudo apt update
sudo apt install squid -y

sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
sudo cat <<EOF > /etc/squid/squid.conf
  access_log /var/log/squid/access.log

  acl localnet src 0.0.0.1-0.255.255.255  # RFC 1122 "this" network (LAN)
  acl localnet src 10.0.0.0/8             # RFC 1918 local private network (LAN)
  acl localnet src 100.64.0.0/10          # RFC 6598 shared address space (CGN)
  acl localnet src 169.254.0.0/16         # RFC 3927 link-local (directly plugged) machines
  acl localnet src 172.16.0.0/12          # RFC 1918 local private network (LAN)
  acl localnet src 192.168.0.0/16         # RFC 1918 local private network (LAN)
  acl localnet src fc00::/7               # RFC 4193 local private network range
  acl localnet src fe80::/10              # RFC 4291 link-local (directly plugged) machines

  acl SSL_ports port 443
  acl SSL_ports port 6443
  acl SSL_ports port 8084

  acl Safe_ports port 80          # http
  acl Safe_ports port 21          # ftp
  acl Safe_ports port 443         # https
  acl Safe_ports port 70          # gopher
  acl Safe_ports port 210         # wais
  acl Safe_ports port 1025-65535  # unregistered ports
  acl Safe_ports port 280         # http-mgmt
  acl Safe_ports port 488         # gss-http
  acl Safe_ports port 591         # filemaker
  acl Safe_ports port 777         # multiling http
  acl Safe_ports port 6443

  acl HCI_Dest_URLs dstdomain   .mcr.microsoft.com
  acl HCI_Dest_URLs dstdomain   azurearcfork8s.azurecr.io
  acl HCI_Dest_URLs dstdomain   linuxgeneva-microsoft.azurecr.io
  acl HCI_Dest_URLs dstdomain   pipelineagent.azurecr.io
  acl HCI_Dest_URLs dstdomain   azurearcfork8sdev.azurecr.io
  acl HCI_Dest_URLs dstdomain   hybridaks.azurecr.io
  acl HCI_Dest_URLs dstdomain   aszk8snetworking.azurecr.io
  acl HCI_Dest_URLs dstdomain   hybridaksstorage.z13.web.core.windows.net
 # acl HCI_Dest_URLs dstdomain  .dl.delivery.mp.microsoft.com
  acl HCI_Dest_URLs dstdomain   .do.dsp.mp.microsoft.com
  acl HCI_Dest_URLs dstdomain   .prod.do.dsp.mp.microsoft.com
  acl HCI_Dest_URLs dstdomain   .dp.kubernetesconfiguration.azure.com
  acl HCI_Dest_URLs dstdomain   sts.windows.net
  acl HCI_Dest_URLs dstdomain   ecpacr.azurecr.io
  acl HCI_Dest_URLs dstdomain   pypi.org
  acl HCI_Dest_URLs dstdomain   files.pythonhosted.org
  acl HCI_Dest_URLs dstdomain   raw.githubusercontent.com
  acl HCI_Dest_URLs dstdomain   msk8s.api.cdp.microsoft.com
 # acl HCI_Dest_URLs dstdomain  msk8s.sb.tlu.dl.delivery.mp.microsoft.com
  acl HCI_Dest_URLs dstdomain   k8connecthelm.azureedge.net
  acl HCI_Dest_URLs dstdomain   kvamanagementoperator.azurecr.io
  acl HCI_Dest_URLs dstdomain   packages.microsoft.com
  acl HCI_Dest_URLs dstdomain   k8sconnectcsp.azureedge.net
  acl HCI_Dest_URLs dstdomain   .prod.hot.ingest.monitor.core.windows.net
  acl HCI_Dest_URLs dstdomain   .dp.prod.appliances.azure.com
  acl HCI_Dest_URLs dstdomain   download.microsoft.com
  acl HCI_Dest_URLs dstdomain   pas.windows.net
  acl HCI_Dest_URLs dstdomain   guestnotificationservice.azure.com
  acl HCI_Dest_URLs dstdomain   .his.arc.azure.com
  acl HCI_Dest_URLs dstdomain   .guestconfiguration.azure.com
  acl HCI_Dest_URLs dstdomain   agentserviceapi.guestconfiguration.azure.com
  acl HCI_Dest_URLs dstdomain   .servicebus.windows.net
  acl HCI_Dest_URLs dstdomain   .waconazure.com
  acl HCI_Dest_URLs dstdomain   .gw.arc.azure.net
  acl HCI_Dest_URLs dstdomain   login.microsoftonline.com
  acl HCI_Dest_URLs dstdomain   graph.windows.net
  acl HCI_Dest_URLs dstdomain   graph.microsoft.com
  acl HCI_Dest_URLs dstdomain   login.windows.net
  acl HCI_Dest_URLs dstdomain   eastus.login.microsoft.com
  acl HCI_Dest_URLs dstdomain   southeastasia.login.microsoft.com
  acl HCI_Dest_URLs dstdomain   crl3.digicert.com
  acl HCI_Dest_URLs dstdomain   crl4.digicert.com
  acl HCI_Dest_URLs dstdomain   www.powershellgallery.com
  acl HCI_Dest_URLs dstdomain   psg-prod-eastus.azureedge.net
  acl HCI_Dest_URLs dstdomain   psg-prod-southeastasia.azureedge.net
  acl HCI_Dest_URLs dstdomain   onegetcdn.azureedge.net
  acl HCI_Dest_URLs dstdomain   portal.azure.com
  acl HCI_Dest_URLs dstdomain   .blob.core.windows.net
  acl HCI_Dest_URLs dstdomain   hciarcvmscontainerregistry.azurecr.io
  acl HCI_Dest_URLs dstdomain   azurestackreleases.download.prss.microsoft.com
  acl HCI_Dest_URLs dstdomain   settings-win.data.microsoft.com
  acl HCI_Dest_URLs dstdomain   dp.stackhci.azure.com
  acl HCI_Dest_URLs dstdomain   licensing.platform.edge.azure.com
  acl HCI_Dest_URLs dstdomain   billing.platform.edge.azure.com
  acl HCI_Dest_URLs dstdomain   azurestackhci.azurefd.net
  acl HCI_Dest_URLs dstdomain   .prod.microsoftmetrics.com
  acl HCI_Dest_URLs dstdomain   dc.services.visualstudio.com
#  acl HCI_Dest_URLs dstdomain  qos.prod.warm.ingest.monitor.core.windows.net
  acl HCI_Dest_URLs dstdomain   .prod.warm.ingest.monitor.core.windows.net
  acl HCI_Dest_URLs dstdomain   gcs.prod.monitoring.core.windows.net
  acl HCI_Dest_URLs dstdomain   adhs.events.data.microsoft.com
  acl HCI_Dest_URLs dstdomain   v20.events.data.microsoft.com
  acl HCI_Dest_URLs dstdomain   aka.ms
  acl HCI_Dest_URLs dstdomain   redirectiontool.trafficmanager.net
#  acl HCI_Dest_URLs dstdomain  fe3.delivery.mp.microsoft.com
#  acl HCI_Dest_URLs dstdomain  tlu.dl.delivery.mp.microsoft.com
  acl HCI_Dest_URLs dstdomain   www.microsoft.com
  acl HCI_Dest_URLs dstdomain   windowsupdate.microsoft.com
# acl HCI_Dest_URLs dstdomain   .download.windowsupdate.com
  acl HCI_Dest_URLs dstdomain   wustat.windows.com
  acl HCI_Dest_URLs dstdomain   ntservicepack.microsoft.com
  acl HCI_Dest_URLs dstdomain   go.microsoft.com
  acl HCI_Dest_URLs dstdomain   .delivery.mp.microsoft.com
 # acl HCI_Dest_URLs dstdomain  .windowsupdate.microsoft.com
  acl HCI_Dest_URLs dstdomain   .windowsupdate.com
  acl HCI_Dest_URLs dstdomain   .update.microsoft.com
  acl HCI_Dest_URLs dstdomain   .endpoint.security.microsoft.com
  acl HCI_Dest_URLs dstdomain   www.office.com
  acl HCI_Dest_URLs dstdomain   login.microsoft.com
  acl HCI_Dest_URLs dstdomain   pythonhosted.org
  acl HCI_Dest_URLs dstdomain   .blob.storage.azure.net
  acl HCI_Dest_URLs dstdomain   oneocsp.microsoft.com
  acl HCI_Dest_URLs dstdomain   ts-crl.ws.symantec.com
  acl HCI_Dest_URLs dstdomain   ts-ocsp.ws.symantec.com
  acl HCI_Dest_URLs dstdomain   s.symcb.com
  acl HCI_Dest_URLs dstdomain   ocsp.digicert.com
  acl HCI_Dest_URLs dstdomain   ocsp2.globalsign.com
  acl HCI_Dest_URLs dstdomain   hciarcvmsstorage.z13.web.core.windows.net
  acl HCI_Dest_URLs dstdomain   management.azure.com
  acl HCI_Dest_URLs dstdomain   developer.microsoft.com
  acl HCI_Dest_URLs dstdomain   .vault.azure.net
  acl HCI_Dest_URLs dstdomain   .prod.hot.ingestion.msftcloudes.com         # optional metrics and telemetry
  acl HCI_Dest_URLs dstdomain   edgesupprd.trafficmanager.net               # optional support
  acl HCI_Dest_URLs dstdomain   .obo.arc.azure.com                          # optional arc - port 8084
  acl HCI_Dest_URLs dstdomain   azurewatsonanalysis-prod.core.windows.net   # optional observability

  acl HCI_Dest_URLs_regex dstdom_regex azgn[a-zA-Z0-9]+?\.servicebus\.windows\.net

  # used to test internet connectivity during HCI node deployment (tests NAT configuration)
  acl testURL dstdomain ipinfo.io

  http_access deny !Safe_ports

  http_access deny CONNECT !SSL_ports

  http_access allow localhost manager
  http_access deny manager

  http_port 3128

  http_access allow testURL
  http_access allow HCI_Dest_URLs_regex
  http_access allow HCI_Dest_URLs
EOF

sudo systemctl restart squid
sudo systemctl enable squid

sudo ufw allow 3128/tcp
