<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:po="http://schemas.contoso.com/purchaseorder">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/po:PurchaseOrder">
    <Order>
      <ID><xsl:value-of select="po:OrderID"/></ID>
      <Date><xsl:value-of select="po:OrderDate"/></Date>
      <Customer><xsl:value-of select="po:CustomerID"/></Customer>
      <Total><xsl:value-of select="po:TotalAmount"/></Total>
    </Order>
  </xsl:template>
</xsl:stylesheet>
