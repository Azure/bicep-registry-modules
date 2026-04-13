<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="discountRate"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/invoice">
    <discountedInvoice>
      <customer>
        <xsl:value-of select="customer"/>
      </customer>
      <originalTotal>
        <xsl:value-of select="totalAmount"/>
      </originalTotal>
      <discountRate>
        <xsl:value-of select="$discountRate"/>
      </discountRate>
      <discountedTotal>
        <xsl:value-of select="format-number(totalAmount * (1 - $discountRate), '#.00')"/>
      </discountedTotal>
    </discountedInvoice>
  </xsl:template>
</xsl:stylesheet>
