<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:cda="urn:hl7-org:v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:jdv="http://esante.gouv.fr"
                xmlns:svs="urn:ihe:iti:svs:2008"
                xmlns:lab="urn:oid:1.3.6.1.4.1.19376.1.3.2"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path-2"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <xsl:processing-instruction xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="xml-stylesheet">type="text/xsl" href="rapportSchematronToHtml4.xsl"</xsl:processing-instruction>
      <xsl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="Rapport de conformit?? du document aux sp??cifications fran??aises (en-t??te)"
                              schemaVersion="CI-SIS_StructurationMinimale.sch">
         <xsl:attribute name="phase">Struct_minimale</xsl:attribute>
         <xsl:attribute name="document">
            <xsl:value-of select="document-uri(/)"/>
         </xsl:attribute>
         <xsl:attribute name="dateHeure">
            <xsl:value-of select="format-dateTime(current-dateTime(), '[D]/[M]/[Y] ?? [H]:[m]:[s] (temps UTC[Z])')"/>
         </xsl:attribute>
         <xsl:text/>
         <svrl:active-pattern>
            <xsl:attribute name="id">addr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">assignedAuthor_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">assignedEntity_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">associatedEntity_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">authenticator_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">author_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">componentOf_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">custodian_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">documentationOf_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">documentEffectiveTime</xsl:attribute>
            <svrl:text>
        V??rification de la conformit?? au CI-SIS d'un ??l??ment de type IVL_TS ou TS du standard CDAr2 :
        L'??l??ment doit porter soit un attribut "value" soit un intervalle ??ventuellement semi-born?? de sous-??l??ments "low", "high". 
        Alternativement, si l'attribut nullFlavor est autoris??, il doit porter l'une des valeurs admises par le CI-SIS. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">informantRelatedEntity_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">informationRecipient_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">inFulfillmentOf_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">legalAuthenticator_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">modeleEntete_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">participant_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">recordTarget_fr</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">relatedDocument_fr</xsl:attribute>
            <svrl:text>
        Si l'??l??ment relatedDocument est pr??sent alors son attribut typeCode doit valoir RPLC 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">serviceEventLabStatusCode</xsl:attribute>
            <svrl:text>
        Contr??le d'utilisation ?? bon escient de l'extension serviceEvent/lab:statusCode autoris??e dans les profils XD-LAB, APSR 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">telecom</xsl:attribute>
            <svrl:text>
        V??rification de la conformit?? au CI-SIS d'un ??l??ment telecom (de type TEL) du standard CDAr2 :
        L'??l??ment doit comporter un attribut "value" bien format?? avec les pr??fixes autoris??s par le CI-SIS, 
        et optionnellement un attribut "use" (qui n'est pas contr??l??).
        Alternativement, si l'attribut nullFlavor est pr??sent, il doit avoir l'une des valeurs admises par le CI-SIS. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_authenticatorSpecialty</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_authorFunctionCode</xsl:attribute>
            <svrl:text>Contr??le de l'appartenance du functionCode ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_authorSpecialty</xsl:attribute>
            <svrl:text>Contr??le de l'appartenance du code sp??cialit?? du PS par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_componentOfResponsibleSpecialty</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_healthcareFacilityCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_informantRelatedEntityCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_legalAuthenticatorSpecialty</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_participantFunctionCode</xsl:attribute>
            <svrl:text>Contr??le de l'appartenance du functionCode ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_participantAssociatedEntityCode</xsl:attribute>
            <svrl:text>Contr??le de l'appartenance du code sp??cialit?? du PS par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_standardIndustryClassCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_typeCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? TRE du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_confidentialityCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_encompassingEncounterCode</xsl:attribute>
            <svrl:text>Contr??le de l'appartenance du componentOf/encompassingEncounterCode/code aux TREs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_healthStatusCodes</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_substanceAdministration_approachSiteCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_problemCodes</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_HL7_allergyintolerance-clinical</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_HL7_conditionclinical</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_actSubstanceAdministrationImmunizationCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_observationIntoleranceType</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_substanceAdministration_ImmunizationRouteCodes</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_vitalSignCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_administrativeGenderCode</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">JDV_SocialHistoryCodes</xsl:attribute>
            <svrl:text>Conformit?? d'un ??l??ment cod?? obligatoire par rapport ?? un jeu de valeurs du CI-SIS</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">variablesSM</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rapport de conformit?? du document aux sp??cifications fran??aises (en-t??te)</svrl:text>

   <!--PATTERN addr-->


	<!--RULE -->
<xsl:template match="cda:addr" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:addr"/>
      <xsl:variable name="nba" select="count(@*)"/>
      <xsl:variable name="nbch" select="count(*)"/>
      <xsl:variable name="val" select="@*"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             ($nba = 0 and $nbch &gt; 0) or             ($nba and name(@*) = 'use' and $nbch &gt; 0) or              ($nba = 1 and name(@*) = 'nullFlavor' and $nbch = 0 and             ($val = 'UNK' or $val = 'NASK' or $val = 'ASKU' or $val = 'NAV' or $val = 'MSK'))              )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [addr.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> ne contient pas un attribut autoris?? pour une adresse, 
            ou est vide et sans nullFlavor, ou contient une valeur de nullFlavor non admise.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$nbch = 0 or                         (cda:streetAddressLine and not(cda:postalCode) and not(cda:city) and not(cda:country) and not(cda:state)                         and not(cda:houseNumber) and not(cda:streetName)and not(cda:additionalLocator) and not(cda:unitID)                         and not(cda:postBox) and not(cda:precinct)) or                         (not(cda:streetAddressLine))                         "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [addr.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> doit ??tre structur?? : 
            - soit sous la formes de lignes d'adresse (streetAddressLine)
            - soit sous la forme de composants ??l??mentaires d'adresse
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN assignedAuthor_fr-->


	<!--RULE -->
<xsl:template match="assignedAuthor" priority="1002" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="assignedAuthor"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de conformit?? CI-SIS :
            L'??l??ment "id" ne peut ??tre pr??sent qu'une seule fois (cardinalit?? [0..1]) dans une assignedAuthor </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id) or(cda:id and (cda:id[@root] and cda:id[@extension]) or cda:id[@nullFlavor])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [assignedAuthor_fr.sch] Erreur de conformit?? CI-SIS : S'il existe, l'??l??ment "id" doit comportant les
            attibuts @root et @extension </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:assignedAuthor/cda:representedOrganization" priority="1001"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:assignedAuthor/cda:representedOrganization"/>
      <xsl:variable name="count_representedOrganization_name" select="count(cda:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id) or (cda:id and cda:id[@root = '1.2.250.1.71.4.2.2'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [assignedAuthor_fr.sch] Erreur de conformit?? CI-SIS : Lorsqu'il est pr??sent, l'??l??ment
            representedOrganization/id doit avoir l'attribut@root='1.2.250.1.71.4.2.2' </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_representedOrganization_name &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur
            de conformit?? CI-SIS : L'??l??ment representedOrganization/name ne peut ??tre pr??sent
            qu'une seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:assignedAuthor/cda:assignedPerson" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:assignedAuthor/cda:assignedPerson"/>
      <xsl:variable name="count_assignedPerson_name" select="count(cda:name)"/>
      <xsl:variable name="count_assignedPerson_family" select="count(cda:name/cda:family)"/>
      <xsl:variable name="count_assignedPerson_given" select="count(cda:name/cda:given)"/>
      <xsl:variable name="count_assignedPerson_prefix" select="count(cda:name/cda:prefix)"/>
      <xsl:variable name="count_assignedPerson_suffix" select="count(cda:name/cda:suffix)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:name or @nullFlavor"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de conformit?? CI-SIS
            : Si l'??l??ment assignedPerson n'est pas vide avec un nullFlavor, alors il doit comporter
            un ??l??ment fils "name" (nullFlavor autoris??). </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_name = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de conformit??
            CI-SIS : L'??l??ment assignedPerson doit contenir un seul et unique ??l??ment name </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_family = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : L'??l??ment assignedPerson/name/family doit ??tre pr??sent et qu'une
            seule fois (cardinalit?? [1..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_given &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/given ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_prefix &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/prefix ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_suffix &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/suffix ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:prefix) or (cda:name/cda:prefix and cda:name/cda:prefix = 'M' or cda:name/cda:prefix = 'MLLE' or cda:name/cda:prefix = 'MME'             or cda:name/cda:prefix = 'DR' or cda:name/cda:prefix = 'MC' or cda:name/cda:prefix = 'MG' or cda:name/cda:prefix = 'PC' or cda:name/cda:prefix = 'PG' or cda:name/cda:prefix = 'PR' or cda:name/cda:prefix/@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/prefix doit faire partie de la table de r??f??rence  TRE_R81-Civilite ('M' ou 'MLLE' ou 'MME')
            ou TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:suffix) or (cda:name/cda:suffix and cda:name/cda:suffix = 'DR' or cda:name/cda:suffix = 'MC' or cda:name/cda:suffix = 'MG'             or cda:name/cda:suffix = 'PC' or cda:name/cda:suffix = 'PG' or cda:name/cda:suffix = 'PR' or cda:name/cda:prefix/@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment  assignedPerson/name/suffix doit faire partie de la table de r??f??rence TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN assignedEntity_fr-->


	<!--RULE -->
<xsl:template match="cda:assignedEntity" priority="1002" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:assignedEntity"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de conformit?? CI-SIS :
            L'??l??ment "id" ne doit ??tre pr??sent qu'une seule et unique fois dans une assignedEntity </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(cda:id[@root] and cda:id[@extension]) or cda:id[@nullFlavor]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [assignedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment "id" doit comportant les
            attibuts @root et @extension </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:assignedEntity/cda:representedOrganization" priority="1001"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:assignedEntity/cda:representedOrganization"/>
      <xsl:variable name="count_representedOrganization_id" select="count(cda:id)"/>
      <xsl:variable name="count_representedOrganization_name" select="count(cda:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id) or (cda:id and cda:id[@root = '1.2.250.1.71.4.2.2'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [assignedEntity_fr.sch] Erreur de conformit?? CI-SIS : Lorsqu'il est pr??sent, l'??l??ment
            representedOrganization/id doit avoir l'attribut@root='1.2.250.1.71.4.2.2' </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_representedOrganization_name &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur
            de conformit?? CI-SIS : L'??l??ment representedOrganization/name ne peut ??tre pr??sent
            qu'une seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:assignedEntity/cda:assignedPerson" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:assignedEntity/cda:assignedPerson"/>
      <xsl:variable name="count_assignedPerson_name" select="count(cda:name)"/>
      <xsl:variable name="count_assignedPerson_family" select="count(cda:name/cda:family)"/>
      <xsl:variable name="count_assignedPerson_given" select="count(cda:name/cda:given)"/>
      <xsl:variable name="count_assignedPerson_prefix" select="count(cda:name/cda:prefix)"/>
      <xsl:variable name="count_assignedPerson_suffix" select="count(cda:name/cda:suffix)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:name or @nullFlavor"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de conformit?? CI-SIS
            : Si l'??l??ment assignedPerson n'est pas vide avec un nullFlavor, alors il doit comporter
            un ??l??ment fils "name" (nullFlavor autoris??). </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_name = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de conformit??
            CI-SIS : L'??l??ment assignedPerson doit contenir un seul et unique ??l??ment name </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_family = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : L'??l??ment assignedPerson/name/family doit ??tre pr??sent et qu'une
            seule fois (cardinalit?? [1..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_given &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/given ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_prefix &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/prefix ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_assignedPerson_suffix &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/suffix ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:prefix) or (cda:name/cda:prefix and cda:name/cda:prefix = 'M' or cda:name/cda:prefix = 'MLLE' or cda:name/cda:prefix = 'MME'             or cda:name/cda:prefix = 'DR' or cda:name/cda:prefix = 'MC' or cda:name/cda:prefix = 'MG' or cda:name/cda:prefix = 'PC' or cda:name/cda:prefix = 'PG' or cda:name/cda:prefix = 'PR' or cda:name/cda:prefix/@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/prefix doit faire partie de la table de r??f??rence  TRE_R81-Civilite ('M' ou 'MLLE' ou 'MME')
            ou TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:suffix) or (cda:name/cda:suffix and cda:name/cda:suffix = 'DR' or cda:name/cda:suffix = 'MC' or cda:name/cda:suffix = 'MG'             or cda:name/cda:suffix = 'PC' or cda:name/cda:suffix = 'PG' or cda:name/cda:suffix = 'PR' or cda:name/cda:prefix/@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment  assignedPerson/name/suffix doit faire partie de la table de r??f??rence TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN associatedEntity_fr-->


	<!--RULE -->
<xsl:template match="cda:associatedEntity" priority="1002" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:associatedEntity"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de conformit?? CI-SIS :
            L'??l??ment "id" ne peut ??tre pr??sent qu'une seule fois (cardinalit?? [0..1]) dans une associatedEntity </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id) or(cda:id and (cda:id[@root] and cda:id[@extension]) or cda:id[@nullFlavor] or cda:id)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [associatedEntity_fr.sch] Erreur de conformit?? CI-SIS : S'il existe, l'??l??ment "id" doit comportant les
            attibuts @root et @extension </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:associatedEntity/cda:scopingOrganization" priority="1001" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:associatedEntity/cda:scopingOrganization"/>
      <xsl:variable name="count_scopingOrganization_name" select="count(cda:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id) or (cda:id and cda:id[@root])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [associatedEntity_fr.sch] Erreur de conformit?? CI-SIS : Lorsqu'il est pr??sent, l'??l??ment
            scopingOrganization/id doit avoir l'attribut @root</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_scopingOrganization_name &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur
            de conformit?? CI-SIS : L'??l??ment scopingOrganization/name ne peut ??tre pr??sent
            qu'une seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:associatedEntity/cda:associatedPerson" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:associatedEntity/cda:associatedPerson"/>
      <xsl:variable name="count_associatedPerson_name" select="count(cda:name)"/>
      <xsl:variable name="count_associatedPerson_family" select="count(cda:name/cda:family)"/>
      <xsl:variable name="count_associatedPerson_given" select="count(cda:name/cda:given)"/>
      <xsl:variable name="count_associatedPerson_prefix" select="count(cda:name/cda:prefix)"/>
      <xsl:variable name="count_associatedPerson_suffix" select="count(cda:name/cda:suffix)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:name or @nullFlavor"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de conformit?? CI-SIS
            : Si l'??l??ment associatedPerson n'est pas vide avec un nullFlavor, alors il doit comporter
            un ??l??ment fils "name" (nullFlavor autoris??). </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_associatedPerson_name = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de conformit??
            CI-SIS : L'??l??ment associatedPerson doit contenir un seul et unique ??l??ment name </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_associatedPerson_family = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : L'??l??ment associatedPerson/name/family doit ??tre pr??sent et qu'une
            seule fois (cardinalit?? [1..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_associatedPerson_given &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment associatedPerson/name/given ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_associatedPerson_prefix &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment associatedPerson/name/prefix ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_associatedPerson_suffix &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment associatedPerson/name/suffix ne peut ??tre pr??sent qu'une
            seule fois (cardinalit?? [0..1]) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:prefix) or (cda:name/cda:prefix and cda:name/cda:prefix = 'M' or cda:name/cda:prefix = 'MLLE' or cda:name/cda:prefix = 'MME'             or cda:name/cda:prefix = 'DR' or cda:name/cda:prefix = 'MC' or cda:name/cda:prefix = 'MG' or cda:name/cda:prefix = 'PC' or cda:name/cda:prefix = 'PG' or cda:name/cda:prefix = 'PR' or cda:name/cda:prefix/@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/prefix doit faire partie de la table de r??f??rence  TRE_R81-Civilite ('M' ou 'MLLE' ou 'MME')
            ou TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:suffix) or (cda:name/cda:suffix and cda:name/cda:suffix = 'DR' or cda:name/cda:suffix = 'MC' or cda:name/cda:suffix = 'MG'             or cda:name/cda:suffix = 'PC' or cda:name/cda:suffix = 'PG' or cda:name/cda:suffix = 'PR' or cda:name/cda:prefix/@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [associatedEntity_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment associatedPerson/name/suffix doit faire partie de la table de r??f??rence TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN authenticator_fr-->


	<!--RULE -->
<xsl:template match="cda:authenticator" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:authenticator"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:time[@value] or cda:time[@nullFlavor]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [authenticator_fr.sch] Erreur de conformit?? CI-SIS :  L'??l??ment time doit contenir l'attribut @value ou un attribut nullFlavor
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:signatureCode[@code='S']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [authenticator] Erreur de conformit?? CI-SIS : L'??l??ment code doit contenir l'attribut @code fix?? ?? la valeur 'S' (pour signed)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN author_fr-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:author" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:author"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:time[@value] or cda:time[@nullFlavor]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [author_fr] L'??l??ment "time" dans "author" doit ??tre pr??sent et renseign??.
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN componentOf_fr-->


	<!--RULE -->
<xsl:template match="cda:componentOf/cda:encompassingEncounter" priority="1003" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:componentOf/cda:encompassingEncounter"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:location) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [componentOf_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment encompassingEncounter/location ne peut ??tre pr??sent qu'une seule fois au maximum [0..1].
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:componentOf/cda:encompassingEncounter/cda:id" priority="1002"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:componentOf/cda:encompassingEncounter/cda:id"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@root"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [componentOf_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment encompassingEncounter/id doit contenir un attribut @root
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:componentOf/cda:encompassingEncounter/cda:code" priority="1001"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:componentOf/cda:encompassingEncounter/cda:code"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@code and @codeSystem and @displayName"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [componentOf_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment encompassingEncounter/code doit contenir les attributs @code, @codeSystem et @displayName
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:componentOf/cda:encompassingEncounter/cda:dischargeDispositionCode"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:componentOf/cda:encompassingEncounter/cda:dischargeDispositionCode"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@code and @displayName"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [componentOf_fr.sch] Erreur de conformit?? au CI-SIS : Les attributs @code et @displayName doit ??tre pr??sent lorque l'??l??ment dischargeDispositionCode est pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(@codeSystem) or (@codeSystem and @codeSystem='1.2.250.1.213.2.14')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [componentOf_fr.sch] Erreur de conformit?? au CI-SIS : L'attribut codeSystem doit avoir la valeur '1.2.250.1.213.2.14' lorsqu'il est pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN custodian_fr-->


	<!--RULE -->
<xsl:template match="cda:representedCustodianOrganization" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:representedCustodianOrganization"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:id[@root='1.2.250.1.71.4.2.2'] or cda:id[@root='1.2.250.1.213.4.1'] or cda:id[@nullFlavor]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [custodian_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment representedCustodianOrganization/id doit ??tre pr??sent et doit contenir l'attribut @root soit ?? la valeur "1.2.250.1.71.4.2.2" ou "1.2.250.1.213.4.1"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [custodian_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment representedCustodianOrganization/id doit ??tre pr??sent qu'une seule fois 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN documentationOf_fr-->


	<!--RULE -->
<xsl:template match="cda:documentationOf" priority="1003" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:documentationOf"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:serviceEvent"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [documentationOf_fr] Erreur de conformit?? CI-SIS : L'??l??ment serviceEvent doit ??tre pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:documentationOf/cda:serviceEvent" priority="1002" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:documentationOf/cda:serviceEvent"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:code) or(cda:code and cda:code[@code] and cda:code[@codeSystem] and cda:code[@displayName]) or (cda:code and cda:code[@nullFlavor])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [documentationOf_fr] Erreur de conformit?? CI-SIS : Lorsqu'il est pr??sent, l'??l??ment code doit contenir les attributs @code, @codeSystem et @displayName ou l???attribut @nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:performer[@typeCode='PRF'] or not(cda:performer)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [documentationOf_fr] Erreur de conformit?? CI-SIS : L'??l??ment serviceEvent/performer, si pr??sent, doit comporter l'attribut @typeCode fix?? ?? "PRF"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:performer) &lt; 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [documentationOf_fr] Erreur de conformit?? CI-SIS : l'en-t??te CDA doit comporter au maximum un seul documentationOf/serviceEvent 
            avec un ??l??ment fils performer. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:documentationOf/cda:serviceEvent/cda:effectiveTime" priority="1001"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:documentationOf/cda:serviceEvent/cda:effectiveTime"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:low and not(@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [documentationOf_fr] Erreur de conformit?? CI-SIS : L'??l??ment effectiveTime du serviceEvent, si pr??sent, ne peut ??tre en nullFlavor et comporte obligatoirement un ??l??ment low
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(@nullFlavor)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [documentationOf_fr] Erreur de conformit?? CI-SIS : L'??l??ment documentationOf/serviceEvent/performer doit ??tre renseign?? sans nullFlavor. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:assignedEntity/cda:representedOrganization/cda:standardIndustryClassCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [documentationOf_fr] Erreur de conformit?? CI-SIS : L'??l??ment documentationOf/serviceEvent/performer correspondant ?? l'acte principal document??, 
            doit comporter un descendant assignedEntity/representedOrganization/standardIndustryClassCode. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN documentEffectiveTime-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:effectiveTime" priority="1002" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:effectiveTime"/>
      <xsl:variable name="L" select="string-length(@value)"/>
      <xsl:variable name="mm" select="number(substring(@value,5,2))"/>
      <xsl:variable name="dd" select="number(substring(@value,7,2))"/>
      <xsl:variable name="hh" select="number(substring(@value,9,2))"/>
      <xsl:variable name="lzp" select="string-length(substring-after(@value,'+'))"/>
      <xsl:variable name="lzm" select="string-length(substring-after(@value,'-'))"/>
      <xsl:variable name="lDH1" select="string-length(substring-before(@value,'+'))"/>
      <xsl:variable name="lDH2" select="string-length(substring-before(@value,'-'))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             ($L = 0) or             ($L = 4) or              ($L = 6 and $mm &lt;= 12) or              ($L = 8 and $mm &lt;= 12 and $dd &lt;= 31) or              ($L &gt; 14 and $mm &lt;= 12 and $dd &lt;= 31 and $hh &lt; 24 and ($lzp = 4 or $lzm = 4) and $lDH1 &lt;= 14 and $lDH2 &lt;= 14)             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IVL_TS.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/effectiveTime'"/>
                  <xsl:text/>/@value = "<xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>"  contient  
            une date et heure invalide, diff??rente de aaaa ou aaaamm ou aaaammjj ou aaaammjjhh[mm[ss]][+/-]zzzz 
            en temps local du producteur.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(@* and not(*)) or (not(@*) and *)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IVL_TS.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/effectiveTime'"/>
                  <xsl:text/> doit contenir soit un attribut soit des ??l??ments fils.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (name(@*) = 'nullFlavor' and 0 and             (@* = 'UNK' or @* = 'NASK' or @* = 'ASKU' or @* = 'NAV' or @* = 'MSK')) or             (name(@*) != 'nullFlavor')              )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IVL_TS.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/effectiveTime'"/>
                  <xsl:text/> contient un 'nullFlavor' non autoris?? ou porteur d'une valeur non admise.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:low and cda:high) or cda:high/@value &gt; cda:low/@value or cda:high/@nullFlavor"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IVL_TS.sch] Erreur de conformit?? CDA : L'??l??ment de temps 'high' doit ??tre sup??rieur ?? l'??l??ment de temps 'low'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:effectiveTime/cda:low" priority="1001"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:effectiveTime/cda:low"/>
      <xsl:variable name="L" select="string-length(@value)"/>
      <xsl:variable name="mm" select="number(substring(@value,5,2))"/>
      <xsl:variable name="dd" select="number(substring(@value,7,2))"/>
      <xsl:variable name="hh" select="number(substring(@value,9,2))"/>
      <xsl:variable name="lzp" select="string-length(substring-after(@value,'+'))"/>
      <xsl:variable name="lzm" select="string-length(substring-after(@value,'-'))"/>
      <xsl:variable name="lDH1" select="string-length(substring-before(@value,'+'))"/>
      <xsl:variable name="lDH2" select="string-length(substring-before(@value,'-'))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             ($L = 0) or             ($L = 4) or              ($L = 6 and $mm &lt;= 12) or              ($L = 8 and $mm &lt;= 12 and $dd &lt;= 31) or              ($L &gt; 14 and $mm &lt;= 12 and $dd &lt;= 31 and $hh &lt; 24 and ($lzp = 4 or $lzm = 4) and $lDH1 &lt;= 14 and $lDH2 &lt;= 14)             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IVL_TS.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/effectiveTime'"/>
                  <xsl:text/>/low/@value = "<xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>"  contient  
            une date et heure invalide, diff??rente de aaaa ou aaaamm ou aaaammjj ou aaaammjjhh[mm[ss]][+/-]zzzz 
            en temps local du producteur.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:effectiveTime/cda:high" priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:effectiveTime/cda:high"/>
      <xsl:variable name="L" select="string-length(@value)"/>
      <xsl:variable name="mm" select="number(substring(@value,5,2))"/>
      <xsl:variable name="dd" select="number(substring(@value,7,2))"/>
      <xsl:variable name="hh" select="number(substring(@value,9,2))"/>
      <xsl:variable name="lzp" select="string-length(substring-after(@value,'+'))"/>
      <xsl:variable name="lzm" select="string-length(substring-after(@value,'-'))"/>
      <xsl:variable name="lDH1" select="string-length(substring-before(@value,'+'))"/>
      <xsl:variable name="lDH2" select="string-length(substring-before(@value,'-'))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             ($L = 0) or             ($L = 4) or              ($L = 6 and $mm &lt;= 12) or              ($L = 8 and $mm &lt;= 12 and $dd &lt;= 31) or              ($L &gt; 14 and $mm &lt;= 12 and $dd &lt;= 31 and $hh &lt; 24 and ($lzp = 4 or $lzm = 4) and $lDH1 &lt;= 14 and $lDH2 &lt;= 14)             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [IVL_TS.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/effectiveTime'"/>
                  <xsl:text/>/high/@value = "<xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>"  contient  
            une date et heure invalide, diff??rente de aaaa ou aaaamm ou aaaammjj ou aaaammjjhh[mm[ss]][+/-]zzzz 
            en temps local du producteur.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN informantRelatedEntity_fr-->


	<!--RULE -->
<xsl:template match="cda:informant/cda:relatedEntity" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:informant/cda:relatedEntity"/>
      <xsl:variable name="count_name" select="count(cda:relatedPerson/cda:name)"/>
      <xsl:variable name="count_family" select="count(cda:relatedPerson/cda:name/cda:family)"/>
      <xsl:variable name="count_given" select="count(cda:relatedPerson/cda:name/cda:given)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="((name(@*) = 'classCode') and              (@* = 'ECON' or @* = 'NOK' or @* = 'CON' or @*='CAREGIVER' or @*='PAT')                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informantRelatedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment informant/relatedEntity doit avoir un attribut classCode dont la valeur est dans l'ensemble :
            (ECON, NOK, CON, CAREGIVER, PAT).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(./cda:addr) &gt;= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informantRelatedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment informant/relatedEntity peut comporter [0..*] adresse g??ographique (nullFlavor autoris??)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(./cda:telecom) &gt;= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informantRelatedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment informant/relatedEntity peut comporter [0..*] adresse telecom (nullFlavor autoris??)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informantRelatedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment informant/relatedEntity/relatedPerson/name doit ??tre pr??sent, mais qu'une seule fois (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_family = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informantRelatedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment informant/relatedEntity/relatedPerson/name/family doit ??tre pr??sent, mais qu'une seule fois (cardinalit?? [1..1])      
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_given &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informantRelatedEntity_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment informant/relatedEntity/relatedPerson/name/family doit ??tre pr??sent au maximum qu'une seule fois (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN informationRecipient_fr-->


	<!--RULE -->
<xsl:template match="cda:informationRecipient/cda:intendedRecipient" priority="1002"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:informationRecipient/cda:intendedRecipient"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>
      <xsl:variable name="count_informationRecipient" select="count(cda:informationRecipient)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id) or (cda:id[@root='1.2.250.1.71.4.2.1'] and cda:id[@extension])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/id si pr??sent doit avoir l'attribut @root fix?? ?? "1.2.250.1.71.4.2.1" et l'attribut @extension doit ??tre pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_informationRecipient &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/informationRecipient ne peut ??tre pr??sent qu'une seule fois au maximum(cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:informationRecipient/cda:intendedRecipient/cda:receivedOrganization"
                 priority="1001"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:informationRecipient/cda:intendedRecipient/cda:receivedOrganization"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>
      <xsl:variable name="count_name" select="count(cda:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id &gt;= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/receivedOrganization/id peut ??tre pr??sent 0 ou plusieurs fois (cardinalit?? [0..*])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name &gt;= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/receivedOrganization/name peut ??tre pr??sent 0 ou plusieurs fois (cardinalit?? [0..*])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:informationRecipient/cda:intendedRecipient/cda:informationRecipient"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:informationRecipient/cda:intendedRecipient/cda:informationRecipient"/>
      <xsl:variable name="count_name" select="count(cda:name)"/>
      <xsl:variable name="count_family" select="count(cda:name/cda:family)"/>
      <xsl:variable name="count_given" select="count(cda:name/cda:given)"/>
      <xsl:variable name="count_prefix" select="count(cda:name/cda:prefix)"/>
      <xsl:variable name="count_suffix" select="count(cda:name/cda:suffix)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name &gt;= 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendRecipient/informationRecipient/name peut ??tre pr??sent 0 ou plusieurs fois (cardinalit?? [0..*])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_family=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/informationRecipient/name/family doit ??tre pr??sent, mais qu'une seule fois (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_given &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/informationRecipient/name/given ne peut ??tre pr??sent qu'une seule fois au maximum (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_prefix &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/informationRecipient/name/prefix ne peut ??tre pr??sent qu'une seule fois au maximum (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_suffix &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [informationRecipient_fr.sch] Erreur de conformit?? au CI-SIS : L'??l??ment intendedRecipient/informationRecipient/name/suffix ne peut ??tre pr??sent qu'une seule fois au maximum (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:prefix) or (cda:name/cda:prefix and cda:name/cda:prefix = 'M' or cda:name/cda:prefix = 'MLLE' or cda:name/cda:prefix = 'MME'             or cda:name/cda:prefix = 'DR' or cda:name/cda:prefix = 'MC' or cda:name/cda:prefix = 'MG' or cda:name/cda:prefix = 'PC' or cda:name/cda:prefix = 'PG' or cda:name/cda:prefix = 'PR' )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [assignedAuthor_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment assignedPerson/name/prefix doit faire partie de la table de r??f??rence  TRE_R81-Civilite ('M' ou 'MLLE' ou 'MME')
            ou TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:name/cda:suffix) or (cda:name/cda:suffix and cda:name/cda:suffix = 'DR' or cda:name/cda:suffix = 'MC' or cda:name/cda:suffix = 'MG'             or cda:name/cda:suffix = 'PC' or cda:name/cda:suffix = 'PG' or cda:name/cda:suffix = 'PR')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> [informationRecipient_fr.sch] Erreur de
            conformit?? CI-SIS : l'??l??ment  assignedPerson/name/suffix doit faire partie de la table de r??f??rence TRE_R11-CiviliteExercice ('DR' ou 'MC' ou 'MG' ou 'PC' ou 'PG' ou 'PR')
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN inFulfillmentOf_fr-->


	<!--RULE -->
<xsl:template match="cda:inFulfillmentOf/cda:order" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:inFulfillmentOf/cda:order"/>
      <xsl:variable name="count_id" select="count(cda:id)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [inFulfillementOf_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment id ne doit ??tre pr??sent qu'une fois (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:id[@root]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [inFulfillementOf_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment id doit contenir un attribut @root
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN legalAuthenticator_fr-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:legalAuthenticator" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:legalAuthenticator"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:time[@value] or cda:time[@nullFlavor]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [legalAuthenticator_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment legalAuthenticator/time doit ??tre pr??sent avec l'attribut @value ou un attribut nullFlavor
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:signatureCode[@code='S']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [legalAuthenticator_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment "signatureCode" doit ??tre pr??sent et contenir l'attribut @code fix?? ?? la valeur 'S'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:assignedEntity"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [legalAuthenticator_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment "assignedEntity" doit ??tre pr??sent 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:assignedEntity/cda:assignedPerson"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [legalAuthenticator_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment "assignedEntity/assignedPerson" doit ??tre pr??sent 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN modeleEntete_fr-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:ClinicalDocument"/>
      <xsl:variable name="count_realmCode" select="count(cda:realmCode)"/>
      <xsl:variable name="count_templateId" select="count(cda:templateId)"/>
      <xsl:variable name="count_recordTarget" select="count(cda:recordTarget)"/>
      <xsl:variable name="count_legalAuthenticator" select="count(cda:legalAuthenticator)"/>
      <xsl:variable name="count_inFulfillmentOf" select="count(cda:inFulfillmentOf)"/>
      <xsl:variable name="count_relatedDocument" select="count(cda:relatedDocument)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_realmCode=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment realmCode doit ??tre pr??sent qu'une seule fois (cardinalit?? [1..1]) 
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:realmCode[@code='FR']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment realmCode doit comporter l'attribut @code fix?? ?? la valeur 'FR'
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:typeId[@root='2.16.840.1.113883.1.3'] and cda:typeId[@extension='POCD_HD000040']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment typeId doit contenir les attributs @root fix?? ?? '2.16.840.1.113883.1.3' et @extension fix?? ?? 'POCD_HD000040'
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_templateId &gt;=3"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment templateId doit contenir au moins trois occurences
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId[@root='2.16.840.1.113883.2.8.2.1']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment templateId contenant l'attribut @root fix?? ?? la valeur '2.16.840.1.113883.2.8.2.1' doit ??tre pr??sent, cela repr??sente la d??claration de conformit?? aux sp??cifications HL7 France
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId[@root='1.2.250.1.213.1.1.1.1']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment templateId contenant l'attribut @root fix?? ?? la valeur '1.2.250.1.213.1.1.1.1' doit ??tre pr??sent, cela repr??sente la d??claration de conformit?? aux sp??cifications du CI-SIS
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:id[@root]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment id doit contenir une valeur d'OID dans l'attribut @root           
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code] and cda:code[@codeSystem] and cda:code[@displayName]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment code doit contenir les attributs @code, @codeSystem, et @displayName
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:title"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment title doit ??tre pr??sent
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:effectiveTime[@value]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment effectiveTime doit contenir l'attribut @value
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:languageCode[@code='fr-FR']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment languageCode doit ??tre pr??sent et contenir l'attribut @code fix?? ?? la valeur 'fr-FR'
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_recordTarget=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment recordTarget doit ??tre pr??sent qu'une seule fois (cardinalit?? [1..1])
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_legalAuthenticator=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment legalAuthenticator doit ??tre pr??sent qu'une seule fois (cardinalit?? [1..1])
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_inFulfillmentOf&gt;=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment inFulfillmentOf peut ??tre pr??sent [0..*].
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:documentationOf"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment documentationOf doit ??tre pr??sent au moins une fois (cardinalit?? [1..*])
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_relatedDocument&lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment relatedDocuement doit ??tre pr??sent qu'une seule fois au maximum (cardinalit?? [0..1])
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:componentOf"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [modeleEntete_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment componentOf est obligatoire (cardinalit?? [1..1])
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN participant_fr-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:participant" priority="1002" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:participant"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:time[contains(@xsi:type,':IVL_TS')] or cda:time[@xsi:type='IVL_TS'] or cda:time[@nullFlavor]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/time doit ??tre pr??sent et avoir le type fix?? ?? la valeur 'IVL_TS'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:time/cda:low[@value] or not(cda:time/cda:low)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/time/low doit contenir l'attribut @value
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:time/cda:high[@value] or not(cda:time/cda:high)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/time/high doit contenir l'attribut @value
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:functionCode) or (cda:functionCode/@code and cda:functionCode/@codeSystem) or cda:functionCode/@nullFlavor"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : Les attributs code et codeSystem sont obligatoires dans un ??l??ment functionCode
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:participant/cda:associatedEntity" priority="1001" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:participant/cda:associatedEntity"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@classCode='PROV' or @classCode='AGNT' or @classCode='ECON' or @classCode='GUARD' or @classCode='QUAL' or @classCode='POLHOLD' or              @classCode='CON' or @classCode='CAREGIVER' or @classCode='PAT'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/associatedEntity[@classCode] doit faire partie de TRE_R260-HL7RoleClass(2.16.840.1.113883.5.110).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:code) or (cda:code and cda:code[@code] and cda:code[@codeSystem] and cda:code[@displayName])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/associatedEntity/code doit contenir les attributs @code, @codeSystem et @displayName lorsqu'il est pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:participant/cda:associatedEntity/associatedPerson" priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:participant/cda:associatedEntity/associatedPerson"/>
      <xsl:variable name="count_name" select="count(cda:name)"/>
      <xsl:variable name="count_family" select="count(cda:name/cda:family)"/>
      <xsl:variable name="count_given" select="count(cda:name/cda:given)"/>
      <xsl:variable name="count_prefix" select="count(cda:name/cda:prefix)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/associatedEntity/associatedPerson/name doit ??tre pr??sent, mais qu'une seule fois (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_family=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/associatedEntity/associatedPerson/name/family doit ??tre pr??sent, mais qu'une seule fois (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_given &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/associatedEntity/associatedPerson/name/given peut ??tre pr??sent au maximum qu'une seule fois (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_prefix &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [participant_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment participant/associatedEntity/associatedPerson/name/prefix peut ??tre pr??sent au maximum qu'une seule fois (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN recordTarget_fr-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:recordTarget/cda:patientRole" priority="1003"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:recordTarget/cda:patientRole"/>
      <xsl:variable name="count_name_patient" select="count(cda:patient/cda:name)"/>
      <xsl:variable name="count_patient_name_qualifier"
                    select="count(cda:patient/cda:name/cda:given/@qualifier)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:id[@nullFlavor])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment recordTarget/patientRole/id (obligatoire dans CDAr2), 
            doit ??tre sans nullFlavor. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name_patient = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment recordTarget/patientRole/patient/name ne doit ??tre pr??sent qu'une fois
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_patient_name_qualifier = 0 or ($count_patient_name_qualifier &gt;0 and (cda:patient/cda:name/cda:given/@qualifier='BR' or cda:patient/cda:name/cda:given/@qualifier='CL'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : S'il existe, l'attribut @qualifier de l'??lement name/given doit etre @qualifier='BR' ou @qualifier='CL'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="             not(cda:patient/cda:religiousAffiliationCode) and             not(cda:patient/cda:raceCode) and             not(cda:patient/cda:ethnicGroupCode)              "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : Un ??l??ment recordTarget/patientRole/patient 
            ne doit contenir ni race ni religion ni groupe ethnique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:patient/cda:birthTime"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : l'??l??ment recordTarget/patientRole/patient/birthTime doit ??tre pr??sent 
            avec une date de naissance ou un nullFlavor autoris??.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(cda:id/@root='1.2.250.1.213.1.4.8') and not(cda:id/@root='1.2.250.1.213.1.4.9') and not(cda:id/@root='1.2.250.1.213.1.4.10') and not(cda:id/@root='1.2.250.1.213.1.4.11'))             and cda:id/@extension             or (cda:patient/cda:name/cda:family/@qualifier             and cda:patient/cda:name/cda:given             and cda:patient/cda:birthTime             and cda:patient/cda:administrativeGenderCode             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : Dans le cadre de l'INS, les traits de l'INS (Nom de naissance, premier pr??nom, date de naissance et sexe) sont obligatoires
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:patient/cda:name/cda:family/@qualifier='BR' or cda:patient/cda:name/cda:family/@qualifier='SP' or cda:patient/cda:name/cda:family/@qualifier='CL'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment patient/name/family/@qualifier prend l'une des valeurs suivantes : "BR" pour le nom de famille
            "SP" pour le nom d???usage
            "CL" pour le nom utilis?? (RNIV)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:patient/cda:name/cda:given/@qualifier='BR' or cda:patient/cda:name/cda:given/@qualifier='CL' or not(cda:patient/cda:name/cda:given/@qualifier)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : Si pr??sent, l'??l??ment patient/name/given/@qualifier prend l'une des valeurs suivantes :
            "BR" pour le premier pr??nom extrait de la liste des pr??noms de l???acte de naissance
            "CL" pour pour le pr??nom utilis?? (RNIV)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:family"
                 priority="1002"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:family"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@qualifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'attribut @qualifier est obligatoire d'ans l'??l??ment family
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@qualifier=&#34;BR&#34; or @qualifier=&#34;CL&#34; or @qualifier=&#34;SP&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment patient/name/family/@qualifier prend l'une des valeurs suivantes : "BR" pour le nom de famille
            "SP" pour le nom d???usage
            "CL" pour le nom utilis?? (RNIV)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given"
                 priority="1001"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@qualifier='BR' or @qualifier='CL' or not(@qualifier)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : Si pr??sent, L'??l??ment patient/name/given/@qualifier prend l'une des valeurs suivantes :
            "BR" pour le premier pr??nom extrait de la liste des pr??noms de l???acte de naissance
            "CL" pour pour le pr??nom utilis?? (RNIV)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian"/>
      <xsl:variable name="count_name_guardianPerson" select="count(cda:guardianPerson/cda:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name_guardianPerson &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment recordTarget/patientRole/patient/guardian/guardianPerson/name ne doit ??tre pr??sent qu'une fois (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="count_name_guardianOrganization"
                    select="count(cda:guardianOrganization/cda:name)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_name_guardianOrganization &lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [recordTarget_fr.sch] Erreur de conformit?? CI-SIS : L'??l??ment recordTarget/patientRole/patient/guardian/guardianOrganization/name ne doit ??tre pr??sent qu'une fois (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN relatedDocument_fr-->


	<!--RULE -->
<xsl:template match="cda:relatedDocument" priority="1000" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:relatedDocument"/>
      <xsl:variable name="count_id" select="count(cda:parentDocument/cda:id)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@typeCode='RPLC'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [relatedDocument_fr.sch] Erreur de conformit?? CI-SIS : ClinicalDocument/relatedDocument ne contient pas l'attribut typeCode avec la seule valeur autoris??e : RPLC.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_id = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [relatedDocument_fr.sch] Erreur de conformit?? CI-SIS : ClinicalDocument/relatedDocument/parentDocument/id doit ??tre pr??sent une seule fois
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:parentDocument/cda:id[@root]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [relatedDocument_fr.sch] Erreur de conformit?? CI-SIS : ClinicalDocument/relatedDocument/parentDocument/id doit contenir un ??l??ment root 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN serviceEventLabStatusCode-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/lab:statusCode"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/lab:statusCode"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../../../cda:code[@code='11502-2' or @code='11526-1']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            Erreur de conformit?? CI-SIS : L'extension documentationOf/serviceEvent/lab:statusCode n'est autoris??e 
            que dans les CR de biologie ou les CR d'anatomie et de cytologie pathologiques
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@code = 'active' or @code = 'completed' "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            Erreur de conformit?? CI-SIS : L'??l??ment documentationOf/serviceEvent/lab:statusCode doit poss??der un attribut @code.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN telecom-->


	<!--RULE -->
<xsl:template match="cda:telecom" priority="1000" mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:telecom"/>
      <xsl:variable name="prefix" select="substring-before(@value, ':')"/>
      <xsl:variable name="suffix" select="substring-after(@value, ':')"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (count(@*) = 1 and name(@*) = 'nullFlavor' and             (@* = 'UNK' or @* = 'NASK' or @* = 'ASKU' or @* = 'NAV' or @* = 'MSK')) or             ($suffix and (             $prefix = 'tel' or              $prefix = 'fax' or              $prefix = 'mailto' or              $prefix = 'http' or              $prefix = 'ftp' or              $prefix = 'mllp'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [telecom.sch] Erreur de conformit?? CI-SIS : <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> n'est pas conforme ?? une adresse de t??l??communication pr??fixe:cha??ne 
            (avec pr??fixe = tel, fax, mailto, http, ftp ou mllp) 
            ou est vide et sans nullFlavor, ou contient un nullFlavor non admis.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=" @use = 'H'                      or @use = 'HP'                      or @use = 'HV'                      or @use = 'WP'                     or @use = 'DIR'                      or @use = 'PUB'                      or @use = 'EC'                      or @use = 'MC'                      or @use = 'PG'                      or not(@use)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [telecom.sch] Erreur de conformit?? CI-SIS : L'attribut use de l'??l??ment telecom n'est pas conforme. 
            Il est facultatif et les valeurs permises sont 'H','HP', 'HV','WP','DIR','PUB','EC','MC','PG'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN JDV_authenticatorSpecialty-->


	<!--RULE -->
<xsl:template match="cda:authenticator/cda:assignedEntity/cda:code" priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:authenticator/cda:assignedEntity/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'authenticator/assignedEntity/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'authenticator/assignedEntity/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_authenticatorSpecialty)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'authenticator/assignedEntity/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_authenticatorSpecialty"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN JDV_authorFunctionCode-->


	<!--RULE -->
<xsl:template match="cda:author/cda:functionCode" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cda:author/cda:functionCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractFunctionCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'author/functionCode'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code et @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_authorFunctionCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_authorFunctionCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_authorFunctionCode_3)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractFunctionCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'author/functionCode'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_authorFunctionCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorFunctionCode_2"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorFunctionCode_3"/>
                  <xsl:text/> .
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN JDV_authorSpecialty-->


	<!--RULE -->
<xsl:template match="cda:author/cda:assignedAuthor/cda:code" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:author/cda:assignedAuthor/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractSpecialty] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'author/assignedAuthor/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem and @displayName) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractSpecialty] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'author/assignedAuthor/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem et @displayName renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_authorSpecialty_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_authorSpecialty_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_authorSpecialty_3)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])or (document($jdv_authorSpecialty_4)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_authorSpecialty_5)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or (document($jdv_authorSpecialty_5)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            
            [abstractSpecialty] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'author/assignedAuthor/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_authorSpecialty_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorSpecialty_2"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorSpecialty_3"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorSpecialty_4"/>
                  <xsl:text/>
            ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorSpecialty_5"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_authorSpecialty_6"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN JDV_componentOfResponsibleSpecialty-->


	<!--RULE -->
<xsl:template match="cda:componentOf/cda:encompassingEncounter/cda:responsibleParty/cda:assignedEntity/cda:code"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:componentOf/cda:encompassingEncounter/cda:responsibleParty/cda:assignedEntity/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'componentOf/encompassingEncounter/responsibleParty/assignedEntity/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'componentOf/encompassingEncounter/responsibleParty/assignedEntity/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_componentOfResponsibleSpecialty)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'componentOf/encompassingEncounter/responsibleParty/assignedEntity/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_componentOfResponsibleSpecialty"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN JDV_healthcareFacilityCode-->


	<!--RULE -->
<xsl:template match="cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:code"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractHealthcareFacilityCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'componentOf/encompassingEncounter/location/healtCareFacility/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem and @displayName) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractHealthcareFacilityCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'componentOf/encompassingEncounter/location/healtCareFacility/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem et @displayName renseign??s, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_healthcareFacilityCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_healthcareFacilityCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractHealthcareFacilityCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'componentOf/encompassingEncounter/location/healtCareFacility/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_healthcareFacilityCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_healthcareFacilityCode_2"/>
                  <xsl:text/> .
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN JDV_informantRelatedEntityCode-->


	<!--RULE -->
<xsl:template match="cda:informant/cda:relatedEntity/cda:code" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:informant/cda:relatedEntity/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractInformantRelatedEntityCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'informant/relatedEntity/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem and @displayName) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractInformantRelatedEntityCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'informant/relatedEntity/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem et @displayName renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_informantRelatedEntityCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_informantRelatedEntityCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractInformantRelatedEntityCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'informant/relatedEntity/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_informantRelatedEntityCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_informantRelatedEntityCode_2"/>
                  <xsl:text/> .
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN JDV_legalAuthenticatorSpecialty-->


	<!--RULE -->
<xsl:template match="cda:legalAuthenticator/cda:assignedEntity/cda:code" priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:legalAuthenticator/cda:assignedEntity/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'legalAuthenticator/assignedEntity/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'legalAuthenticator/assignedEntity/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_legalAuthenticatorSpecialty)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'legalAuthenticator/assignedEntity/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_legalAuthenticatorSpecialty"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN JDV_participantFunctionCode-->


	<!--RULE -->
<xsl:template match="cda:participant/cda:functionCode" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:participant/cda:functionCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractFunctionCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'participant/functionCode'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code et @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_participantFunctionCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_participantFunctionCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_participantFunctionCode_3)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractFunctionCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'participant/functionCode'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_participantFunctionCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantFunctionCode_2"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantFunctionCode_3"/>
                  <xsl:text/> .
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN JDV_participantAssociatedEntityCode-->


	<!--RULE -->
<xsl:template match="cda:participant/cda:associatedEntity/cda:code" priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:participant/cda:associatedEntity/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractSpecialty] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'participant/associatedEntity/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem and @displayName) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractSpecialty] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'participant/associatedEntity/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem et @displayName renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_participantAssociatedEntityCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_participantAssociatedEntityCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_participantAssociatedEntityCode_3)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])or (document($jdv_participantAssociatedEntityCode_4)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_participantAssociatedEntityCode_5)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or (document($jdv_participantAssociatedEntityCode_5)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            
            [abstractSpecialty] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'participant/associatedEntity/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_participantAssociatedEntityCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantAssociatedEntityCode_2"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantAssociatedEntityCode_3"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantAssociatedEntityCode_4"/>
                  <xsl:text/>
            ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantAssociatedEntityCode_5"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_participantAssociatedEntityCode_6"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN JDV_standardIndustryClassCode-->


	<!--RULE -->
<xsl:template match="cda:standardIndustryClassCode" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:standardIndustryClassCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractStandardIndustryClassCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'standardIndustryClassCode'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem and @displayName) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractStandardIndustryClassCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'standardIndustryClassCode'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem et @displayName renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_standardIndustryClassCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_standardIndustryClassCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractStandardIndustryClassCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'standardIndustryClassCode'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_standardIndustryClassCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_standardIndustryClassCode_2"/>
                  <xsl:text/> .
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN JDV_typeCode-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:code" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractTypeCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractTypeCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_typeCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             or  (document($jdv_typeCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractTypeCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_typeCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_typeCode_2"/>
                  <xsl:text/> .
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN JDV_confidentialityCode-->


	<!--RULE -->
<xsl:template match="cda:ClinicalDocument/cda:confidentialityCode" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:ClinicalDocument/cda:confidentialityCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/confidentialityCode'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/confidentialityCode'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_confidentialityCode)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/confidentialityCode'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_confidentialityCode"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN JDV_encompassingEncounterCode-->


	<!--RULE -->
<xsl:template match="cda:componentOf/cda:encompassingEncounter/cda:code" priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:componentOf/cda:encompassingEncounter/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractEncompassingEncounterCode] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/componentOf/encompassingEncounter/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code et @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_encompassingEncounterCode_1)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem]) or  (document($jdv_encompassingEncounterCode_2)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [abstractEncompassingEncounterCode] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'ClinicalDocument/componentOf/encompassingEncounter/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_encompassingEncounterCode_1"/>
                  <xsl:text/> ou <xsl:text/>
                  <xsl:value-of select="$jdv_encompassingEncounterCode_2"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN JDV_healthStatusCodes-->


	<!--RULE -->
<xsl:template match="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1.2']/cda:value"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1.2']/cda:value"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'entryRelationship/observation/value'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'entryRelationship/observation/value'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_healthStatusCodes)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'entryRelationship/observation/value'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_healthStatusCodes"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN JDV_substanceAdministration_approachSiteCode-->


	<!--RULE -->
<xsl:template match="cda:substanceAdministration/cda:approachSiteCode" priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:substanceAdministration/cda:approachSiteCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'substanceAdministration/approachSiteCode'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'substanceAdministration/approachSiteCode'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_substanceAdministration_approachSiteCode)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'substanceAdministration/approachSiteCode'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_substanceAdministration_approachSiteCode"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN JDV_problemCodes-->


	<!--RULE -->
<xsl:template match="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5' and not (cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6')]/cda:code"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.5' and not (cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6')]/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'entry/observation/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'entry/observation/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_problemCodes)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'entry/observation/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_problemCodes"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN JDV_HL7_allergyintolerance-clinical-->


	<!--RULE -->
<xsl:template match="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6' or cda:templateId/@root='2.16.840.1.113883.10.20.1.54']/cda:entryRelationship/cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/cda:value"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6' or cda:templateId/@root='2.16.840.1.113883.10.20.1.54']/cda:entryRelationship/cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/cda:value"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'observation/entryRelationship/observation/value'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'observation/entryRelationship/observation/value'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_HL7_allergyintolerance-clinical)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'observation/entryRelationship/observation/value'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_HL7_allergyintolerance-clinical"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN JDV_HL7_conditionclinical-->


	<!--RULE -->
<xsl:template match="cda:observation[not(cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6' or cda:templateId/@root='2.16.840.1.113883.10.20.1.54')]/cda:entryRelationship/cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/cda:value"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[not(cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6' or cda:templateId/@root='2.16.840.1.113883.10.20.1.54')]/cda:entryRelationship/cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.1.1']/cda:value"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'observation/entryRelationship/observation/value'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'observation/entryRelationship/observation/value'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_HL7_conditionclinical)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'observation/entryRelationship/observation/value'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_HL7_conditionclinical"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN JDV_actSubstanceAdministrationImmunizationCode-->


	<!--RULE -->
<xsl:template match="cda:substanceAdministration[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/cda:code"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:substanceAdministration[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12']/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="substanceAdministration/code"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="substanceAdministration/code"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_actSubstanceAdministrationImmunizationCode)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="substanceAdministration/code"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_actSubstanceAdministrationImmunizationCode"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN JDV_observationIntoleranceType-->


	<!--RULE -->
<xsl:template match="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6']/cda:code"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.6']/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="observation/code"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="observation/code"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_observationIntoleranceType)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="observation/code"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_observationIntoleranceType"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN JDV_substanceAdministration_ImmunizationRouteCodes-->


	<!--RULE -->
<xsl:template match="cda:substanceAdministration[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12' or cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12.2']/cda:routeCode"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:substanceAdministration[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12' or cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.12.2']/cda:routeCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="substanceAdministration/routeCode"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="substanceAdministration/routeCode"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_substanceAdministration_ImmunizationRouteCodes)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="substanceAdministration/routeCode"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_substanceAdministration_ImmunizationRouteCodes"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN JDV_vitalSignCode-->


	<!--RULE -->
<xsl:template match="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.2']/cda:code"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13.2']/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'observation/code'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'observation/code'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_vitalSignCode)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'observation/code'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_vitalSignCode"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN JDV_administrativeGenderCode-->


	<!--RULE -->
<xsl:template match="//cda:administrativeGenderCode" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cda:administrativeGenderCode"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'administrativeGenderCode'"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (1 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="'administrativeGenderCode'"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_administrativeGenderCode)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="'administrativeGenderCode'"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_administrativeGenderCode"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN JDV_SocialHistoryCodes-->


	<!--RULE -->
<xsl:template match="cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.52']/cda:code"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.52']/cda:code"/>
      <xsl:variable name="att_code" select="@code"/>
      <xsl:variable name="att_codeSystem" select="@codeSystem"/>
      <xsl:variable name="att_displayName" select="@displayName"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(@nullFlavor) or 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="observation[templateId/@root='1.2.250.1.213.1.1.3.52']/code"/>
                  <xsl:text/>" ne doit pas comporter d'attribut nullFlavor.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             (@code and @codeSystem) or             (0 and              (@nullFlavor='UNK' or              @nullFlavor='NA' or              @nullFlavor='NASK' or              @nullFlavor='ASKU' or              @nullFlavor='NI' or              @nullFlavor='NAV' or              @nullFlavor='MSK' or              @nullFlavor='OTH')) or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE'))             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [dansJeuDeValeurs] L'??l??ment "<xsl:text/>
                  <xsl:value-of select="observation[templateId/@root='1.2.250.1.213.1.1.3.52']/code"/>
                  <xsl:text/>" doit avoir ses attributs 
            @code, @codeSystem renseign??s, ou si le nullFlavor est autoris??, une valeur admise pour cet attribut, ou un xsi:type diff??rent de CD ou CE.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(             @nullFlavor or             (@xsi:type and not(@xsi:type = 'CD') and not(@xsi:type = 'CE')) or              (document($jdv_SocialHistoryCodes)//svs:Concept[@code=$att_code and @codeSystem=$att_codeSystem])             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        
            [dansJeuDeValeurs] L'??l??ment <xsl:text/>
                  <xsl:value-of select="observation[templateId/@root='1.2.250.1.213.1.1.3.52']/code"/>
                  <xsl:text/>
            [<xsl:text/>
                  <xsl:value-of select="$att_code"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_displayName"/>
                  <xsl:text/>:<xsl:text/>
                  <xsl:value-of select="$att_codeSystem"/>
                  <xsl:text/>] 
            doit faire partie du jeu de valeurs <xsl:text/>
                  <xsl:value-of select="$jdv_SocialHistoryCodes"/>
                  <xsl:text/>.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN variablesSM-->
<xsl:variable name="jdv_authenticatorSpecialty"
                 select="'../../jeuxDeValeurs/JDV_AuthorSpecialty-CISIS.xml'"/>
   <xsl:variable name="jdv_authorFunctionCode_1"
                 select="'../../jeuxDeValeurs/TRE_R258-RelationPriseCharge.xml'"/>
   <xsl:variable name="jdv_authorFunctionCode_2"
                 select="'../../jeuxDeValeurs/TRE_R259-HL7ParticipationFunction.xml'"/>
   <xsl:variable name="jdv_authorFunctionCode_3"
                 select="'../../jeuxDeValeurs/TRE_R85-RolePriseCharge.xml'"/>
   <xsl:variable name="jdv_authorSpecialty_1"
                 select="'../../jeuxDeValeurs/TRE_A02-ProfessionSavFaire-CISIS.xml'"/>
   <xsl:variable name="jdv_authorSpecialty_2"
                 select="'../../jeuxDeValeurs/TRE_A00-ProducteurDocNonPS.xml'"/>
   <xsl:variable name="jdv_authorSpecialty_3"
                 select="'../../jeuxDeValeurs/TRE_R85-RolePriseCharge.xml'"/>
   <xsl:variable name="jdv_authorSpecialty_4"
                 select="'../../jeuxDeValeurs/TRE_R94-ProfessionSocial.xml'"/>
   <xsl:variable name="jdv_authorSpecialty_5"
                 select="'../../jeuxDeValeurs/TRE_R95-UsagerTitre.xml'"/>
   <xsl:variable name="jdv_authorSpecialty_6"
                 select="'../../jeuxDeValeurs/TRE_R96-AutreProfDomSanitaire.xml'"/>
   <xsl:variable name="jdv_componentOfResponsibleSpecialty"
                 select="'../../jeuxDeValeurs/JDV_AuthorSpecialty-CISIS.xml'"/>
   <xsl:variable name="jdv_healthcareFacilityCode_1"
                 select="'../../jeuxDeValeurs/TRE_A00-ProducteurDocNonPS.xml'"/>
   <xsl:variable name="jdv_healthcareFacilityCode_2"
                 select="'../../jeuxDeValeurs/TRE_R02-SecteurActivite.xml'"/>
   <xsl:variable name="jdv_informantRelatedEntityCode"
                 select="'../../jeuxDeValeurs/JDV_J11-RelationPatient-CISIS.xml'"/>
   <xsl:variable name="jdv_informantRelatedEntityCode_1"
                 select="'../../jeuxDeValeurs/TRE_R216-HL7RoleCode.xml'"/>
   <xsl:variable name="jdv_informantRelatedEntityCode_2"
                 select="'../../jeuxDeValeurs/TRE_R217-ProtectionJuridique.xml'"/>
   <xsl:variable name="jdv_legalAuthenticatorSpecialty"
                 select="'../../jeuxDeValeurs/JDV_AuthorSpecialty-CISIS.xml'"/>
   <xsl:variable name="jdv_participantFunctionCode_1"
                 select="'../../jeuxDeValeurs/TRE_R258-RelationPriseCharge.xml'"/>
   <xsl:variable name="jdv_participantFunctionCode_2"
                 select="'../../jeuxDeValeurs/TRE_R259-HL7ParticipationFunction.xml'"/>
   <xsl:variable name="jdv_participantFunctionCode_3"
                 select="'../../jeuxDeValeurs/TRE_R85-RolePriseCharge.xml'"/>
   <xsl:variable name="jdv_participantAssociatedEntityCode_1"
                 select="'../../jeuxDeValeurs/TRE_A02-ProfessionSavFaire-CISIS.xml'"/>
   <xsl:variable name="jdv_participantAssociatedEntityCode_2"
                 select="'../../jeuxDeValeurs/TRE_A00-ProducteurDocNonPS.xml'"/>
   <xsl:variable name="jdv_participantAssociatedEntityCode_3"
                 select="'../../jeuxDeValeurs/TRE_R85-RolePriseCharge.xml'"/>
   <xsl:variable name="jdv_participantAssociatedEntityCode_4"
                 select="'../../jeuxDeValeurs/TRE_R94-ProfessionSocial.xml'"/>
   <xsl:variable name="jdv_participantAssociatedEntityCode_5"
                 select="'../../jeuxDeValeurs/TRE_R95-UsagerTitre.xml'"/>
   <xsl:variable name="jdv_participantAssociatedEntityCode_6"
                 select="'../../jeuxDeValeurs/TRE_R96-AutreProfDomSanitaire.xml'"/>
   <xsl:variable name="jdv_standardIndustryClassCode_1"
                 select="'../../jeuxDeValeurs/TRE_A00-ProducteurDocNonPS.xml'"/>
   <xsl:variable name="jdv_standardIndustryClassCode_2"
                 select="'../../jeuxDeValeurs/TRE_A01-CadreExercice.xml'"/>
   <xsl:variable name="jdv_typeCode_1" select="'../../jeuxDeValeurs/TRE_A04-Loinc.xml'"/>
   <xsl:variable name="jdv_typeCode_2"
                 select="'../../jeuxDeValeurs/TRE_A05-TypeDocComplementaire.xml'"/>
   <xsl:variable name="jdv_confidentialityCode"
                 select="'../../jeuxDeValeurs/TRE_A08-HL7Confidentiality.xml'"/>
   <xsl:variable name="jdv_encompassingEncounterCode_1"
                 select="'../../jeuxDeValeurs/TRE_R304-HL7v3ActCode.xml'"/>
   <xsl:variable name="jdv_encompassingEncounterCode_2"
                 select="'../../jeuxDeValeurs/TRE_R305-TypeRencontre.xml'"/>
   <xsl:variable name="jdv_actSubstanceAdministrationImmunizationCode"
                 select="'../../jeuxDeValeurs/JDV_HL7_ActSubstanceAdministrationImmunizationCode-CISIS.xml'"/>
   <xsl:variable name="jdv_clinicalStatusCodes"
                 select="'../../jeuxDeValeurs/JDV_ClinicalStatusCodes-CISIS.xml'"/>
   <xsl:variable name="jdv_healthStatusCodes"
                 select="'../../jeuxDeValeurs/JDV_HealthStatusCodes-CISIS.xml'"/>
   <xsl:variable name="jdv_observationIntoleranceType"
                 select="'../../jeuxDeValeurs/JDV_HL7_ObservationIntoleranceType-CISIS.xml'"/>
   <xsl:variable name="jdv_problemCodes"
                 select="'../../jeuxDeValeurs/JDV_ProblemCodes-CISIS.xml'"/>
   <xsl:variable name="jdv_HL7_allergyintolerance-clinical"
                 select="'../../jeuxDeValeurs/JDV_HL7_allergyintolerance-clinical-CISIS.xml'"/>
   <xsl:variable name="jdv_HL7_conditionclinical"
                 select="'../../jeuxDeValeurs/JDV_HL7_ConditionClinical-CISIS.xml'"/>
   <xsl:variable name="jdv_substanceAdministration_approachSiteCode"
                 select="'../../jeuxDeValeurs/JDV_ImmunizationApproachSiteCode-CISIS.xml'"/>
   <xsl:variable name="jdv_substanceAdministration_ImmunizationRouteCodes"
                 select="'../../jeuxDeValeurs/JDV_ImmunizationRouteCodes-CISIS.xml'"/>
   <xsl:variable name="jdv_vitalSignCode"
                 select="'../../jeuxDeValeurs/JDV_SignesVitaux-CISIS.xml'"/>
   <xsl:variable name="jdv_administrativeGenderCode"
                 select="'../../jeuxDeValeurs/TRE_R303-HL7v3AdministrativeGen.xml'"/>
   <xsl:variable name="jdv_SocialHistoryCodes"
                 select="'../../jeuxDeValeurs/JDV_SocialHistoryCodes-CISIS.xml'"/>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
</xsl:stylesheet>