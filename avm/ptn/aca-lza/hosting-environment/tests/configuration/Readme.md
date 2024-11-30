# Create a self signed PFX certificate

- If we want our certificate signed, we need a certificate signing request (CSR). The CSR includes the public key and some additional information (such as organization and country). Pay attention to the **Common Name (e.g. server FQDN or YOUR name)**, this must much your domain name, i.e. www.microsoft.com.

```bash
openssl \
    req \
    -nodes \
    -newkey rsa:2048 \
    -keyout acahello.demoapp.com.key \
    -out acahello.demoapp.com.csr \
    -subj "/C=US/ST=WA/L=Redmond/O=LZA/OU=LZA/CN=acahello.demoapp.com/emailAddress=lza@microsoft.com"
```

- Creating a Self-Signed Certificate. A self-signed certificate is a certificate that's signed with its own private key. It can be used to encrypt data just as well as CA-signed certificates, but our users will be shown a warning that says the certificate isn't trusted. Let's create a self-signed certificate (domain.crt) with our existing private key and CSR.

```bash
openssl x509 -signkey acahello.demoapp.com.key -in acahello.demoapp.com.csr -req -days 365 -out acahello.demoapp.com.crt
```

- Convert PEM to PKCS12. PKCS12 files, also known as PFX files, are usually used for importing and exporting certificate chains in Microsoft IIS. We'll use the following command to take our private key and certificate, and then combine them into a PKCS12 file.

```bash
openssl pkcs12 -inkey acahello.demoapp.com.key -in acahello.demoapp.com.crt -export -out acahello.demoapp.com.pfx
```
