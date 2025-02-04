<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0"
  exclude-result-prefixes="xsl tei xs">

  <!-- ==================================================================== -->
  <!--                             IMPORTS                                  -->
  <!-- ==================================================================== -->

  <xsl:import href="../.xslt-datura/tei_to_html/tei_to_html.xsl"/>

  <!-- To override, copy this file into your collection's script directory
    and change the above paths to:
    "../../.xslt-datura/tei_to_html/lib/formatting.xsl"
 -->

  <!-- For display in TEI framework, have changed all namespace declarations to http://www.tei-c.org/ns/1.0. If different (e.g. Whitman), will need to change -->
  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>


  <!-- ==================================================================== -->
  <!--                           PARAMETERS                                 -->
  <!-- ==================================================================== -->

  <xsl:param name="collection"/>
  <xsl:param name="data_base"/>
  <xsl:param name="environment"/>
  <xsl:param name="image_large"/>
  <xsl:param name="image_thumb"/>
  <xsl:param name="image_illustration"/>
  <xsl:param name="media_base"/>
  <xsl:param name="site_url"/>
  
  <xsl:variable name="newline" select="'&#x0A;'"/>
  <xsl:variable name="title" select="//teiHeader//titleStmt//title[1]"/>
  <xsl:variable name="category">record</xsl:variable>
  <xsl:variable name="claimant" select="//body//list/item[child::label = 'Claimant Name']/persName[@type='claimant']"/>
  <xsl:variable name="claimGend" select="//body//list/item/persName[@type='gender']"/>
  <xsl:variable name="appDate" select="//body//list/item[child::label = 'Application Date']/num[@type='date']"/>
  <xsl:variable name="origPlace" select="//body//list/item/placeName[@rend='origin']/@key"/>
  <xsl:variable name="place" select="//body//list/item[child::label = 'Address']//addrLine"/>
  <xsl:variable name="certNum" select="//body//list/item[child::label = 'Final Certificate Number']/num[@type='final']"/>
  <xsl:variable name="document" select="tokenize(base-uri(.),'/')[last()]"/>
  
  <xsl:variable name="liquid_var">{{ base_url | relative_url }}</xsl:variable>

  <!-- ==================================================================== -->
  <!--                            OVERRIDES                                 -->
  <!-- ==================================================================== -->
  
  <!-- Create front matter (YML) header -->
  <xsl:template match="/">
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>title: </xsl:text><xsl:value-of select="$title"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>document: </xsl:text><xsl:value-of select="$document"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>claimant: </xsl:text><xsl:value-of select="$claimant"/>
    <xsl:value-of select="$newline"/>
    <!-- handling differently from other front matter because claimant_alt can be multiple -->
    <xsl:text>claimant_alt: </xsl:text>
    <xsl:for-each select="//body//list/item[child::label = 'Claimant Name (Alternative)']/persName[@type='claimant']">
        <xsl:value-of select="."/><xsl:if test="following::persName[@type='claimant'] != ''"><xsl:text>; </xsl:text></xsl:if>
      </xsl:for-each>
    <xsl:value-of select="$newline"/>
    <xsl:text>claimant_gender: </xsl:text><xsl:value-of select="$claimGend"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>app_date: </xsl:text><xsl:value-of select="$appDate"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>orig_place: </xsl:text><xsl:value-of select="$origPlace"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>place: </xsl:text><xsl:value-of select="$place"/>
    <xsl:value-of select="$newline"/>
    <xsl:text>cert_num: "</xsl:text><xsl:value-of select="format-number($certNum,'0000')"/>"
    <xsl:value-of select="$newline"/>
    <xsl:text>category: record</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>---</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text">
    <div class="results">
      <h1 class="record_title">Claimant: <xsl:value-of select="$claimant"/>; Application Date: <xsl:value-of select="$appDate"/></h1>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="div1">
    <div class="docHit">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="list">
    <xsl:choose>
      <xsl:when test="descendant::head = 'Background Information'"/>
      <xsl:otherwise><ul class="doc_list"><xsl:apply-templates/></ul></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="item">
    <xsl:choose>
      <xsl:when test=". != ''"><li><xsl:apply-templates/></li></xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="item/label">
    <strong><xsl:value-of select="."/></strong><xsl:text>: </xsl:text>
  </xsl:template>
  
  <!-- deal with empty head elements -->
  <xsl:template match="text//head">
    <xsl:choose>
      <xsl:when test=". = ''"/>
      <xsl:when test="ancestor::list"><h3 class="listHead"><xsl:apply-templates/></h3></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="placeName">
    <span class="placeName"><xsl:apply-templates/></span>
  </xsl:template>
  
</xsl:stylesheet>
