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
                xmlns:pharm="urn:ihe:pharm"
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
                              title="V??rification de la conformit?? des sections et entr??es cr????es par l'ANS"
                              schemaVersion="CI-SIS_Modeles_ANS.sch">
         <xsl:attribute name="phase">CI-SIS_Modeles_ANS</xsl:attribute>
         <xsl:attribute name="document">
            <xsl:value-of select="document-uri(/)"/>
         </xsl:attribute>
         <xsl:attribute name="dateHeure">
            <xsl:value-of select="format-dateTime(current-dateTime(), '[D]/[M]/[Y] ?? [H]:[m]:[s] (temps UTC[Z])')"/>
         </xsl:attribute>
         <xsl:text/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_allergiesIntolerances_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_anamnese_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_anamneseEtFacteursDeRisques_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_antecedentsMedicaux_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_bilan-diagnostic-immediat_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_bilanPre-therapeutique_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_cadrePropositionTherapeutique_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_comment_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_conclusionCR-ACP_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_conclusionCRO_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_diagnosticSortie_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_dispositifs_medicaux_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_dispositionsMedicoSociales_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_documentsAjoutes_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_documentsReferences_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_dossier_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_elementsCliniquesRapportes_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_facteursDeRisque_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_facteursDeRisque-non-code_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_historiqueExamensBiologiques_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_informationAssure_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_laborAndDelivery_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_motifHospitalisation-non-code_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_noteProgression_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_pathologieAntecedentsAllergiesFacteursDeRiques_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_pathologieAntecedentsAllergies_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_planTraitement_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_protheseEtObjetPersonnel_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_resultatExamBio-non-code_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_resultatLaboBioSeconde_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_scoreEvaluationClinique_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_scoreGlasgow_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_scoreNIHSS_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_scoreRankin_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_statutDoc_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_statutDossierRCP_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_traitementsMaladiesRares_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_traitementsSortie-non-code_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_travailAccouchement-non-code_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_dispositions_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_travailEtAccouchement_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">S_principalMotif-non-code_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_dispositifMedical-2_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_dispositifMedicalComplement_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_dispositifMedicalImplante_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_enRapportAccidentTravail_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_enRapportALD_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_horsAMM_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_nonRemboursable_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_observationNIHSSComponent_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_observationScoreNIHSS_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_organizerDocumentAttache_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_organizerRCP_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="id">E_organizerTraitementInitialAVC_ANS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? des sections et entr??es cr????es par l'ANS</svrl:text>

   <!--PATTERN S_allergiesIntolerances_ANSV??rification de la conformit?? de la section FR-Allergies-et-intolerances-non-code (1.2.250.1.213.1.1.2.8) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Allergies-et-intolerances-non-code (1.2.250.1.213.1.1.2.8) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.8&#34;]" priority="1000"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.8&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_allergiesIntolerances_ANS] Erreur de conformit?? CI-SIS : Cet ??l??ment FR-Allergies-et-intolerances-non-code ne peut ??tre utilis?? que comme section. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;48765-2&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_allergiesIntolerances_ANS] Erreur de conformit?? CI-SIS : Le code de la section FR-Allergies-et-intolerances-non-code doit ??tre 48765-2
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_allergiesIntolerances_ANS] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? dans la nomenclature LOINC (2.16.840.1.113883.6.1). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

   <!--PATTERN S_anamnese_ANSV??rification de la conformit?? de la section FR-Anamnese (1.2.250.1.213.1.1.2.69) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Anamnese (1.2.250.1.213.1.1.2.69) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.69&#34;]" priority="1000"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.69&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamnese_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_anamnese_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;34117-2&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamnese_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section 'ANAMNESE' doit ??tre '34117-2' 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamnese_ANS.sch] Erreur de conformit?? CI-SIS : L'attribut 'codeSystem' de la section a pour valeur '2.16.840.1.113883.6.1' (LOINC). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(cda:component/cda:section) and cda:text) or (count(cda:component/cda:section)&lt;=5 and not(cda:text) and (cda:component/cda:section))             and (cda:component/cda:section/cda:templateId[             @root = '1.3.6.1.4.1.19376.1.5.3.1.3.6' or             @root = '1.3.6.1.4.1.19376.1.5.3.1.3.8' or             @root = '1.3.6.1.4.1.19376.1.5.3.1.3.12' or             @root = '1.3.6.1.4.1.19376.1.5.3.1.3.13' or             @root = '1.3.6.1.4.1.19376.1.5.3.1.3.15'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_anamnese_ANS.sch] Erreur de conformit?? CI-SIS : 
            Si aucune des 5 sous-sections optionnelles n???est pr??sente : l?????l??ment 'text' est obligatoire.
            Si les 5 sous-sections sont pr??sentes : l?????l??ment 'text' est interdit. En effet, chacune est porteuse de son propre 'text' en plus de ses donn??es structur??es.            
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

   <!--PATTERN S_anamneseEtFacteursDeRisques_ANSV??rification de la conformit?? de la section FR-Anamnese-et-facteurs-de-risques (1.2.250.1.213.1.1.2.68) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Anamnese-et-facteurs-de-risques (1.2.250.1.213.1.1.2.68) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.68&#34;]" priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.68&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de onformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;46612-8&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section 'ANAMNESE ET FACTEURS DE RISQUES' doit ??tre '46612-8' 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de conformit?? CI-SIS :  L'attribut 'codeSystem' du code de la section doit ??tre '2.16.840.1.113883.6.1' (LOINC). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:component/cda:section/cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.69&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de conformit?? CI-SIS : Cette section Anamn??se et facteurs de risques doit contenir la section FR Anamn??se (1.2.250.1.213.1.1.2.69).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(//cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de conformit?? CI-SIS : Si elle existe, La sous-section optionnelle Facteurs de risques professionnels (Hazardous working conditions - 1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1) ne doit ??tre pr??sente qu'une seule fois [0..1].
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(//cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.3.16']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_anamneseEtFacteursDeRisques_ANS.sch] Erreur de conformit?? CI-SIS :  Si elle existe, La sous-section optionnelle Habitus, Mode de vie (Social History - 1.3.6.1.4.1.19376.1.5.3.1.3.16) ne doit ??tre pr??sente qu'une seule fois [0..1].
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN S_antecedentsMedicaux_ANSV??rification de la conformit?? de la section FR-Antecedents-medicaux-non-code (1.2.250.1.213.1.1.2.2) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Antecedents-medicaux-non-code (1.2.250.1.213.1.1.2.2) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.2&#34;]" priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.2&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_antecedentsMedicaux_ANS.sch] erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_antecedentsMedicaux_ANS.sch] erreur de conformit?? CI-SIS : Cette section doit contenir un id unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_antecedentsMedicaux_ANS.sch] erreur de conformit?? CI-SIS : Cette section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;11348-0&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_antecedentsMedicaux_ANS.sch] erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '11348-0' 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_antecedentsMedicaux_ANS.sch] erreur de conformit?? CI-SIS : L'attribut 'codeSystem' du 'code' de la section doit ??tre '2.16.840.1.113883.6.1' (LOINC). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN S_bilan-diagnostic-immediat_ANSV??rification de la Section FR-Bilan-diagnostic-immediat-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la Section FR-Bilan-diagnostic-immediat</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.59&#34;]" priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.59&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:code[@code = &#34;72135-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilan-diagnostic-immediat_ANS.sch] Erreur de conformit?? : Le code de la section FR-Bilan-diagnostic-immediat (1.2.250.1.213.1.1.2.59) doit ??tre "72135-7".
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilan-diagnostic-immediat_ANS.sch] Erreur de conformit?? : Le code de la section FR-Bilan-diagnostic-immediat (1.2.250.1.213.1.1.2.59) doit faire partie de la nomenclature LOINC.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:templateId[@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.3.28&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilan-diagnostic-immediat_ANS.sch] Erreur de conformit?? : La section FR-Resultats-examens (1.3.6.1.4.1.19376.1.5.3.1.3.28) est obligatoire dans la section FR-Bilan-diagnostic-immediat (1.2.250.1.213.1.1.2.59).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:templateId[@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.3.36&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilan-diagnostic-immediat_ANS.sch] Erreur de conformit?? : La section FR-Plan-de-soins (1.3.6.1.4.1.19376.1.5.3.1.3.36) est obligatoire dans la section FR-Bilan-diagnostic-immediat (1.2.250.1.213.1.1.2.59).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN S_bilanPre-therapeutique_ANSV??rification de la conformit?? de la section FR-Bilan-pretherapeutique (1.2.250.1.213.1.1.2.42) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Bilan-pretherapeutique (1.2.250.1.213.1.1.2.42) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.42&#34;]" priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.42&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_bilanPre-therapeutique_ANS.sch] Erreur de Conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilanPre-therapeutique_ANS.sch]  Erreur de Conformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilanPre-therapeutique_ANS.sch]  Erreur de Conformit?? CI-SIS : La section doit contenir un ??l??ment text
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;AVC-182&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_bilanPre-therapeutique_ANS.sch] Erreur de Conformit?? CI-SIS : Le code de la section Abdomen doit ??tre AVC-182
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:organizer/cda:templateId/@root='1.2.250.1.213.1.1.3.16'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreGlasgow_ANS.sch]  Erreur de Conformit?? CI-SIS : Les entr??es optionnelles autoris??es sont : 
            Organizer Traitement initial AVC (1.2.250.1.213.1.1.3.16)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN S_cadrePropositionTherapeutique_ANSV??rification de la conformit?? de la section FR-Cadre-de-la-proposition-therapeutique (1.2.250.1.213.1.1.2.45) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Cadre-de-la-proposition-therapeutique (1.2.250.1.213.1.1.2.45) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.45&#34;]" priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.45&#34;]"/>
      <xsl:variable name="count_templateId" select="count(cda:templateId)"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="$count_templateId &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un templateId
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;35510-7&#34;] or cda:code[@code = &#34;56447-6&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '35510-7' "Essais cliniques - Informations g??n??rales"
            ou '35510-7' "Note sur le plan de soins"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="//cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_cadrePropositionTherapeutique_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e Simple observation est obligatoire (1.3.6.1.4.1.19376.1.5.3.1.4.13)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN S_comment_ANS-->


	<!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.47&#34;]" priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.47&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_comment_ANS] Erreur de conformit?? CI-SIS : Ce composant ne peut ??tre utilis?? qu'en tant que section. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;48767-8&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_comment_ANS] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre 48767-8 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_comment_ANS] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre tir?? de la terminologie LOINC (2.16.840.1.113883.6.1). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:templateId[@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.4.13&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            
            [S_comment_ANS] Erreur de conformit?? CI-SIS : La section doit contenir des entr??es 
            du type Simple Observation Entry  (1.3.6.1.4.1.19376.1.5.3.1.4.13).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN S_conclusionCR-ACP_ANSV??rification de la conformit?? de la section FR-Conclusion-du-CR-ACP (1.2.250.1.213.1.1.2.34) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Conclusion-du-CR-ACP (1.2.250.1.213.1.1.2.34) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.34&#34;]" priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.34&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCR-ACP_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCR-ACP_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment text
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_conclusionCR-ACP_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;30954-2&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCR-ACP_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre 30954-2
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCR-ACP_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:component/cda:section)              or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'              or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.8.1.2.6'             or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.8.1.2.5'             or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.4.1.2.16'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCR-ACP_ANS.sch] Erreur de conformit?? CI-SIS : Les sous sections optionelles autoris??es sont : 
            FR-Simple-Observation (1.3.6.1.4.1.19376.1.5.3.1.4.13)
            FR-Prelevements (1.3.6.1.4.1.19376.1.8.1.2.6)  
            FR-Conclusion-diagnostic (1.3.6.1.4.1.19376.1.8.1.2.5)            
            FR-Commentaire-non-code (1.3.6.1.4.1.19376.1.4.1.2.16)                      
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN S_conclusionCRO_ANSV??rification de la conformit?? de la section FR-Conclusion-de-CRO (1.2.250.1.213.1.1.2.26) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Conclusion-de-CRO (1.2.250.1.213.1.1.2.26) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.26&#34;]" priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.26&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_conclusionCRO_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCRO_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCRO_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;10218-6&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCRO_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section FR-Conclusion-de-CRO doit ??tre '10218-6'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_conclusionCRO_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN S_diagnosticSortie_ANSV??rification de la conformit?? de la section FR-Diagnostic-de-sortie-non-code (1.2.250.1.213.1.1.2.5) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Diagnostic-de-sortie-non-code (1.2.250.1.213.1.1.2.5) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.5&#34;]" priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.5&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_diagnosticSortie_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)&lt;2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_diagnosticSortie_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir au maximum un ??l??ment 'id'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;11535-2&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_diagnosticSortie_ANS.sch] Erreur de conformit?? CI-SIS : Le 'code' de la section doit ??tre '11535-2'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN S_dispositifs_medicaux_ANSV??rification de la conformit?? de la section FR-Dispositifs-medicaux (1.2.250.1.213.1.1.2.1) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Dispositifs-medicaux (1.2.250.1.213.1.1.2.1) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.2.1']" priority="1002"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.2.1']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;46264-8&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section FR-Dispositifs-medicaux doit ??tre '46264-8'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' correspond ?? la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:organizer/cda:templateId/@root='1.2.250.1.213.1.1.3.2' or cda:entry/cda:supply/cda:templateId/@root='1.2.250.1.213.1.1.3.20'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : La section FR-Dispositifs-medicaux doit contenir des entr??es 'Dipositif m??dical' :
            - de type 'organizer' (1.2.250.1.213.1.1.3.2) (ancienne version utilis??e uniquement pour les volets PRC et LDL) ;
            - de type 'supply' (1.2.250.1.213.1.1.3.20) (nouvelle version). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.2.1']/cda:entry/cda:organizer/cda:templateId"
                 priority="1001"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.2.1']/cda:entry/cda:organizer/cda:templateId"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(../../../cda:entry/cda:supply)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : La section FR-Dispositifs-medicaux doit contenir des entr??es 'Dipositif m??dical' de type organizer (1.2.250.1.213.1.1.3.2) ou de type supply (1.2.250.1.213.1.1.3.20) mais pas les deux
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="not(@root='1.2.250.1.213.1.1.3.2')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(@root='1.2.250.1.213.1.1.3.2')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : La section FR-Dispositifs-medicaux doit contenir des entr??es 'Dipositif m??dical' de type 'organizer' (1.2.250.1.213.1.1.3.2) (ancienne version utilis??e uniquement pour les volets PRC et LDL) ;
        </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.2.1']/cda:entry/cda:supply/cda:templateId"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.2.1']/cda:entry/cda:supply/cda:templateId"/>

		    <!--REPORT -->
<xsl:if test="not(@root='1.2.250.1.213.1.1.3.20' or @root='2.16.840.1.113883.10.20.1.34' or @root='2.16.840.1.113883.10.22.4.26')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(@root='1.2.250.1.213.1.1.3.20' or @root='2.16.840.1.113883.10.20.1.34' or @root='2.16.840.1.113883.10.22.4.26')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : La section FR-Dispositifs-medicaux doit contenir des entr??es 'Dipositif m??dical' de type 'supply' (1.2.250.1.213.1.1.3.20 et 2.16.840.1.113883.10.20.1.35) (nouvelle version). 
        </svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:templateId/@root='1.2.250.1.213.1.1.3.20'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositifs_medicaux_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e 'Dipositif m??dical' de type 'supply' doit avoir le templateId root="1.2.250.1.213.1.1.3.20"
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN S_dispositionsMedicoSociales_ANSV??rification de la conformit?? de la section FR-Dispositions-medico-sociales (1.2.250.1.213.1.1.2.44) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Dispositions-medico-sociales (1.2.250.1.213.1.1.2.44) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.44&#34;]" priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.44&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_dispositionsMedicoSociales_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositionsMedicoSociales_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositionsMedicoSociales_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;34841-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositionsMedicoSociales_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section FR-Dispositions-medico-sociales doit ??tre '34841-7'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositionsMedicoSociales_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositionsMedicoSociales_ANS.sch] Erreur de conformit?? CI-SIS : Les entr??es optionnelles autoris??es sont : 
            simple observation (1.3.6.1.4.1.19376.1.5.3.1.4.13)     
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN S_documentsAjoutes_ANSV??rification de la conformit?? de la section FR-Documents-ajoutes (1.2.250.1.213.1.1.2.37) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Documents-ajoutes (1.2.250.1.213.1.1.2.37) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.37&#34;]" priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.37&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_documentsAjoutes_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)&lt;2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_documentsAjoutes_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir au maximum un seul 'id'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_documentsAjoutes_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;55107-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_documentsAjoutes_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '55107-7'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_documentsAjoutes_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre un code LOINC  
            system (2.16.840.1.113883.6.1). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="//cda:templateId[@root = &#34;1.2.250.1.213.1.1.3.18&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_documentsAjoutes_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e Document attach?? (1.2.250.1.213.1.1.3.18) est obligatoirement pr??sente dans cette section
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN S_documentsReferences_ANSV??rification de la conformit?? de la section FR-Documents-references (1.2.250.1.213.1.1.2.55) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Documents-references (1.2.250.1.213.1.1.2.55) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.55&#34;]" priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.55&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_documentsReferences_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_documentsReferences_ANS.sch] Erreur de conformit?? CI-SIS : La section R??f??rences externes doit contenir un ??l??ment text.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;55107-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_documentsReferences_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '55107-7'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_documentsReferences_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre un code LOINC  
            system (2.16.840.1.113883.6.1). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="//cda:templateId[@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.4.4&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_documentsReferences_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e FR-References-externes (1.3.6.1.4.1.19376.1.5.3.1.4.4) est obligatoirement pr??sente dans cette section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN S_dossier_ANSV??rification de la conformit?? de la section FR-Dossier (1.2.250.1.213.1.1.2.66) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Dossier (1.2.250.1.213.1.1.2.66) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.66&#34;]" priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.66&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_dossier_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)&lt;2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dossier_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir au maximum un seul 'id' (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;GEN-168&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dossier_ANS.sch] Erreur de conformit?? CI-SIS : Le 'code' de la section FR-Dossier doit ??tre 'GEN-168'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN S_elementsCliniquesRapportes_ANSV??rification de la conformit?? de la section FR-Elements-cliniques-rapportes (1.2.250.1.213.1.1.2.46) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Elements-cliniques-rapportes (1.2.250.1.213.1.1.2.46) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.46&#34;]" priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.46&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : Cette section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : Cette section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;55107-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : Le 'code' de la section doit ??tre '55107-7' 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : L'attribut 'codeSystem' de la section a pour valeur '2.16.840.1.113883.6.1' (LOINC). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:templateId[@root = &#34;1.2.250.1.213.1.1.3.18&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : Cette section doit contenir un organizer 'Document Attach??'. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(.//cda:templateId[@root = &#34;1.2.250.1.213.1.1.3.18&#34;])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           
            [S_elementsCliniquesRapportes_ANS.sch] Erreur de conformit?? CI-SIS : L'organizer 'Document Attach??' de cette section doit ??tre identifi?? comme 'Information Clinique'. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN S_facteursDeRisque_ANSV??rification de la conformit?? de la section FR-Facteurs-de-risques (1.2.250.1.213.1.1.2.31) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Facteurs-de-risques (1.2.250.1.213.1.1.2.31) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.31&#34;]" priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.31&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_facteursDeRisque_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque_ANS.sch] Erreur de conformit?? CI-SIS :: La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;57207-3&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '57207-3'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:component/cda:section) or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.16.1' or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1' or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.15'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque_ANS.sch] Erreur de conformit?? CI-SIS : Les sous-sections optionnelles possibles sont :  
            Habitus, mode de vie (Coded Social History - 1.3.6.1.4.1.19376.1.5.3.1.3.16.1)
            Facteurs de risque professionnels (Hazardous Working Conditions - 1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1)
            Ant??c??dents familiaux (Coded Family Medical History - 1.3.6.1.4.1.19376.1.5.3.1.3.15)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(cda:component/cda:section) and cda:text) or (count(cda:component/cda:section)=3 and not(cda:text)) or (count(cda:component/cda:section)&lt;3 and cda:component/cda:section)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque_ANS.sch] Erreur de conformit?? CI-SIS : 
            Si aucune des 3 sous-sections optionnelles n???est pr??sente : l?????l??ment text est requis . Dans ce cas le contenu de la section est int??gralement non structur??.
            Si les 3 sous-sections optionnelles sont pr??sentes : l?????l??ment text est interdit. En effet, chacune est porteuse de son propre texte en plus de ses donn??es structur??es. Ce cas correspond ?? la structuration maximale de cette section.
            Dans les autres cas, l?????l??ment text peut ??tre pr??sent et il porte le texte correspondant ?? une ou plusieurs sous-sections optionnelles absentes.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN S_facteursDeRisque-non-code_ANSV??rification de la conformit?? de la section FR-Facteurs-de-risques-non-code (1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Facteurs-de-risques-non-code (1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1&#34;]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_facteursDeRisque-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cette section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;10161-8&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '10161-8'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_facteursDeRisque-non-code_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN S_historiqueExamensBiologiques_ANSV??rification de la conformit?? de la section FR-Historique-des-examens-biologiques (1.2.250.1.213.1.1.2.28) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Historique-des-examens-biologiques (1.2.250.1.213.1.1.2.28) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.28&#34;]" priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.28&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_historiqueExamensBiologiques_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_historiqueExamensBiologiques_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_historiqueExamensBiologiques_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;26436-6&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_historiqueExamensBiologiques_ANS.sch] Erreur de conformit?? CI-SIS : Le 'code' de cette section doit ??tre '57074-7'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_historiqueExamensBiologiques_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:component/cda:section) or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.7.3.1.1.13.7'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_historiqueExamensBiologiques_ANS.sch] Erreur de conformit?? CI-SIS : Cette section peut contenir une sous-section FR-Resultats-evenements (1.3.6.1.4.1.19376.1.7.3.1.1.13.7).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN S_informationAssure_ANSV??rification de la conformit?? de la section FR-Informations-assure (1.2.250.1.213.1.1.2.38) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Informations-assure (1.2.250.1.213.1.1.2.38) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.38&#34;]" priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.38&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_InformationAssure_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_InformationAssure_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_InformationAssure_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;35525-5&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_InformationAssure_ANS.sch] Erreur de conformit?? CI-SIS : Le 'code' de la section doit ??tre '35525-5'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:organizer/cda:templateId/@root='1.2.250.1.213.1.1.3.18'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_InformationAssure_ANS.sch] Erreur de conformit?? CI-SIS : Les entr??es optionnelles autoris??es sont FR-Document-attache (1.2.250.1.213.1.1.3.18).    
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN S_laborAndDelivery_ANSV??rification de la conformit?? de la section FR-Travail-et-accouchement-non-code (1.2.250.1.213.1.1.2.13) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Travail-et-accouchement-non-code (1.2.250.1.213.1.1.2.13) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.13&#34;]" priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.13&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_laborAndDelivery_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_laborAndDelivery_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_laborAndDelivery_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;57074-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_laborAndDelivery_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '57074-7'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_laborAndDelivery_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN S_motifHospitalisation-non-code_ANSV??rification de la conformit?? de la section FR-Motif-d-hospitalisation-non-code (1.2.250.1.213.1.1.2.6) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Motif-d-hospitalisation-non-code (1.2.250.1.213.1.1.2.6) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.6&#34;]" priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.6&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_MotifHospitalisation-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_MotifHospitalisation-non-code_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;46241-6&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_MotifHospitalisation-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '46241-6'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_MotifHospitalisation-non-code_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN S_noteProgression_ANSSection note de progression ANS -->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Section note de progression ANS </svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.25&#34;]" priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.25&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_noteProgression_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_noteProgression_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_noteProgression_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;18733-6&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_noteProgression_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '18733-6'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_noteProgression_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="//cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_noteProgression_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e Simple observation est obligatoire (1.3.6.1.4.1.19376.1.5.3.1.4.13)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN S_pathologieAntecedentsAllergiesFacteursDeRiques_ANSV??rification de la conformit?? de la section FR-Pathologies-antecedents-allergies-facteurs-de-risques (1.2.250.1.213.1.1.2.29) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Pathologies-antecedents-allergies-facteurs-de-risques (1.2.250.1.213.1.1.2.29) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.29&#34;]" priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.29&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_pathologieAntecedentsAllergiesFacteursDeRiques_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergiesFacteursDeRiques_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;46612-8&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergiesFacteursDeRiques_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '46612-8'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergiesFacteursDeRiques_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:component/cda:section/cda:templateId/@root='1.2.250.1.213.1.1.2.30' and cda:component/cda:section/cda:templateId/@root='1.2.250.1.213.1.1.2.31'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergiesFacteursDeRiques_ANS.sch] Erreur de conformit?? CI-SIS : Cette section contient obligatoirement les sous sections 'Pathologie en cours, ant??c??dents et allergies'
            (1.2.250.1.213.1.1.2.30) et 'Facteurs de risque' (1.2.250.1.213.1.1.2.31)           
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN S_pathologieAntecedentsAllergies_ANSV??rification de la conformit?? de la section FR-Pathologies-antecedents-allergies (1.2.250.1.213.1.1.2.30) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Pathologies-antecedents-allergies (1.2.250.1.213.1.1.2.30) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.30&#34;]" priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.30&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_pathologieAntecedentsAllergies_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergies_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;34117-2&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergies_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section Pathologie, ant??c??dents, allergies doit ??tre '34117-2'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergies_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:component/cda:section) or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.6' or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.8'             or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.12' or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergies_ANS.sch] Erreur de conformit?? CI-SIS : Les sous-sections optionnelles possibles sont :  
            Probl??mes actifs (Active problems - 1.3.6.1.4.1.19376.1.5.3.1.3.6)
            Ant??c??dents m??dicaux (History of past illness - 1.3.6.1.4.1.19376.1.5.3.1.3.8)
            Ant??c??dents chirurgicaux (Coded List of Surgeries - 1.3.6.1.4.1.19376.1.5.3.1.3.12)
            Allergies et intol??rances (Allergies and intolerances - 1.3.6.1.4.1.19376.1.5.3.1.3.13)            
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(cda:component/cda:section) and cda:text) or (count(cda:component/cda:section)=4 and not(cda:text)) or (count(cda:component/cda:section)&lt;4 and cda:component/cda:section)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_pathologieAntecedentsAllergies_ANS.sch] Erreur de conformit?? CI-SIS : 
            Si aucune des 4 sous-sections optionnelles n???est pr??sente : l?????l??ment text est requis. Dans ce cas le contenu de la section est int??gralement non structur??.
            Si les 4 sous-sections optionnelles sont pr??sentes : l?????l??ment text est interdit. En effet, chacune est porteuse de son propre texte en plus de ses donn??es structur??es. Ce cas correspond ?? la structuration maximale de cette section.
            Dans les autres cas, l?????l??ment text peut ??tre pr??sent et il porte le texte correspondant ?? une ou plusieurs sous-sections optionnelles absentes.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN S_planTraitement_ANSV??rification de la conformit?? de la section FR-Plan-de-traitement (1.2.250.1.213.1.1.2.32) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Plan-de-traitement (1.2.250.1.213.1.1.2.32) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.32&#34;]" priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.32&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_planTraitement_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_planTraitement_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;18776-5&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_planTraitement_ANS.sch] Erreur de conformit?? CI-SIS :: Le code de la section doit ??tre '18776-5'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_planTraitement_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:component/cda:section) or cda:component/cda:section/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.3.19'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_planTraitement_ANS.sch] Erreur de conformit?? CI-SIS : La sous-section optionnelle est la section Traitements (Medications - 1.3.6.1.4.1.19376.1.5.3.1.3.19).         
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(not(cda:component/cda:section) and cda:text) or (cda:component/cda:section and not(cda:text))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_planTraitement_ANS.sch] Erreur de conformit?? CI-SIS : 
            La section doit contenir un ??l??ment 'text' s???il n???y a pas de sous-section Traitements (1.3.6.1.4.1.19376.1.5.3.1.3.19).
            La section ne doit pas contenir d?????l??ment 'text' s???il y a une sous-section Traitements (1.3.6.1.4.1.19376.1.5.3.1.3.19)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN S_protheseEtObjetPersonnel_ANSV??rification de la conformit?? de la section FR-Protheses-et-objets-personnels (1.2.250.1.213.1.1.2.53) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Protheses-et-objets-personnels (1.2.250.1.213.1.1.2.53) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.53&#34;]" priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.53&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_ProtheseEtObjetPersonnel_ANS] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_ProtheseEtObjetPersonnel_ANS] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_ProtheseEtObjetPersonnel_ANS] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;46264-8&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_ProtheseEtObjetPersonnel_ANS] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre '46264-8'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_ProtheseEtObjetPersonnel_ANS] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_ProtheseEtObjetPersonnel_ANS] Erreur de conformit?? CI-SIS : Les entr??es optionnelles autoris??es sont : 
            simple observation (1.3.6.1.4.1.19376.1.5.3.1.4.13)     
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

   <!--PATTERN S_resultatExamBio-non-code_ANSV??rification de la conformit?? de la section FR-Resultats-examens-biologiques-non-code (1.2.250.1.213.1.1.2.10) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Resultats-examens-biologiques-non-code (1.2.250.1.213.1.1.2.10) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.10&#34;]" priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.10&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_resultatExamBio-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_resultatExamBio-non-code_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_resultatExamBio-non-code_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment text
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>

   <!--PATTERN S_resultatLaboBioSeconde_ANSV??rification de la conformit?? de la section FR-Resultats-de-laboratoire-de-biologie-de-seconde-intention (1.2.250.1.213.1.1.2.60) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Resultats-de-laboratoire-de-biologie-de-seconde-intention (1.2.250.1.213.1.1.2.60) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.60&#34;]" priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.60&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_resultatLaboBioSeconde_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_resultatLaboBioSeconde_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>

   <!--PATTERN S_scoreEvaluationClinique_ANSV??rification de la conformit?? de la section FR-Scores-evaluation-clinique (1.2.250.1.213.1.1.2.41) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Scores-evaluation-clinique (1.2.250.1.213.1.1.2.41) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.41&#34;]" priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.41&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_scoreEvaluationClinique_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreEvaluationClinique_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreEvaluationClinique_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;47420-5&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreEvaluationClinique_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '47420-5'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreEvaluationClinique_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="//cda:templateId/@root='1.2.250.1.213.1.1.2.40' and //cda:templateId/@root='1.2.250.1.213.1.1.2.40' and //cda:templateId/@root='1.2.250.1.213.1.1.2.36'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreEvaluationClinique_ANS.sch] Erreur de conformit?? CI-SIS : Les section optionnelles autoris??es sont : 
            FR-Score-de-Rankin (1.2.250.1.213.1.1.2.39),
            FR-Score-de-Glasgow (1.2.250.1.213.1.1.2.40),
            FR-Scores-NIHSS (1.2.250.1.213.1.1.2.36).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>

   <!--PATTERN S_scoreGlasgow_ANSV??rification de la conformit?? de la section FR-Score-de-Glasgow (1.2.250.1.213.1.1.2.40) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Score-de-Glasgow (1.2.250.1.213.1.1.2.40) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.40&#34;]" priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.40&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_scoreGlasgow_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreGlasgow_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreGlasgow_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;35088-4&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreGlasgow_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '35088-4'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreGlasgow_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreGlasgow_ANS.sch] Erreur de conformit?? CI-SIS : Les entr??es optionnelles autoris??es sont de type simple observation (1.3.6.1.4.1.19376.1.5.3.1.4.13)     
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>

   <!--PATTERN S_scoreNIHSS_ANSV??rification de la conformit?? de la section FR-Scores-NIHSS (1.2.250.1.213.1.1.2.36) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Scores-NIHSS (1.2.250.1.213.1.1.2.36) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.36&#34;]" priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.36&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_scoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;70182-1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '70182-1'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e optionnelle autoris??e est l'entr??e simple observation (1.3.6.1.4.1.19376.1.5.3.1.4.13).        
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>

   <!--PATTERN S_scoreRankin_ANSV??rification de la conformit?? de la section FR-Score-de-Rankin (1.2.250.1.213.1.1.2.39) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Score-de-Rankin (1.2.250.1.213.1.1.2.39) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.39&#34;]" priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.39&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_scoreRankin_ANS.sch] Erreur de conformit?? CI-SIS : cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreRankin_ANS.sch] Erreur de conformit?? CI-SIS : la section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreRankin_ANS.sch] Erreur de conformit?? CI-SIS : la section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;75859-9&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreRankin_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cett section doit ??tre '75859-9'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_scoreRankin_ANS.sch] Erreur de conformit?? CI-SIS : Les entr??es optionnelles autoris??es sont de type simple observation (1.3.6.1.4.1.19376.1.5.3.1.4.13).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>

   <!--PATTERN S_statutDoc_ANSV??rification de la conformit?? de la section FR-Statut-du-document (1.2.250.1.213.1.1.2.35) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Statut-du-document (1.2.250.1.213.1.1.2.35) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.35&#34;]" priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.35&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_statutDoc_ANS] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;33557-0&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_statutDoc_ANS] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '33557-0'       .       
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_statutDoc_ANS] Erreur de conformit?? CI-SIS :  L'??l??ment 'codeSystem' de cette section doit ??tre cod?? dans la nomenclature LOINC (2.16.840.1.113883.6.1)
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
            [S_statutDoc_ANS] Erreur de conformit?? CI-SIS : Cette section doit avoir un titre significatif de son contenu.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDoc_ANS] Erreur de conformit?? CI-SIS : La section doit avoir un identifiant unique permettant de les identifier.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:entry/cda:observation/cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDoc_ANS] Erreur de conformit?? CI-SIS : Cette section comporte obligatoirement une simple Observation
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>

   <!--PATTERN S_statutDossierRCP_ANSV??rification de la conformit?? de la section FR-Statut-dossier-RCP (1.2.250.1.213.1.1.2.33) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Statut-dossier-RCP (1.2.250.1.213.1.1.2.33) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.33&#34;]" priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.33&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_statutDossierRCP_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDossierRCP_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDossierRCP_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;21874-3&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDossierRCP_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '21874-3'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDossierRCP_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entry) or cda:entry/cda:organizer/cda:templateId/@root='1.2.250.1.213.1.1.3.7'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_statutDossierRCP_ANS.sch] Erreur de conformit?? CI-SIS : L'entr??e optionnelle autoris??e est organizer RCP (1.2.250.1.213.1.1.3.7).        
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>

   <!--PATTERN S_traitementsMaladiesRares_ANSV??rification de la conformit?? de la section FR-Traitements-maladies-rares (1.2.250.1.213.1.1.2.54) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Traitements-maladies-rares (1.2.250.1.213.1.1.2.54) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.54&#34;]" priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.54&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsMaladiesRares_ANS] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que pour une section. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;10160-0&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsMaladiesRares_ANS] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '10160-0'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsMaladiesRares_ANS] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre un code LOINC (2.16.840.1.113883.6.1). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test=".//cda:templateId[@root = &#34;1.2.250.1.213.1.1.3.13&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsMaladiesRares_ANS] Erreur de conformit?? CI-SIS : Cette section doit contenir des entr??es de type "Traitement Maladie rare" (1.2.250.1.213.1.1.3.13).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>

   <!--PATTERN S_traitementsSortie-non-code_ANSV??rification de la conformit?? de la section FR-Traitements-a-la-sortie-non-cod?? (1.2.250.1.213.1.1.2.4) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Traitements-a-la-sortie-non-cod?? (1.2.250.1.213.1.1.2.4) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.4&#34;]" priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.2.4&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsSortie-non-code_ANS] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que pour une section. 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;10183-2&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsSortie-non-code_ANS] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '10183-2' 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_traitementsSortie-non-code_ANS] Erreur de conformit?? CI-SIS : Le code de la section doit ??tre un code LOINC (2.16.840.1.113883.6.1). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>

   <!--PATTERN S_travailAccouchement-non-code_ANSV??rification de la conformit?? de la section FR-Travail-et-accouchement-non-code (1.2.250.1.213.1.1.2.13) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Travail-et-accouchement-non-code (1.2.250.1.213.1.1.2.13) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.13&#34;]" priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.13&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_travailAccouchement-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_travailAccouchement-non-code_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;57074-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_travailAccouchement-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '57074-7'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_travailAccouchement-non-code_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>

   <!--PATTERN S_dispositions_ANSV??rification de la conformit?? de la section FR-Dispositions (1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Dispositions (1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.172&#34;]" priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.172&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_dispositions_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)&lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositions_ANS.sch] Erreur de conformit?? CI-SIS : La section doit contenir au maximum un seul id (cardinalit?? [0..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;11302-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_dispositions_ANS.sch] Erreur de conformit?? CI-SIS : Le code de la section 'FR-Dispositions' doit ??tre '11302-7' 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_dispositions_ANS.sch] Erreur de conformit?? CI-SIS : L'attribut 'codeSystem' de la section a pour valeur '2.16.840.1.113883.6.1' (LOINC). 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:text"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositions_ANS.sch] Erreur de conformit?? CI-SIS : l?????l??ment 'text' est obligatoire.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:entry/cda:act[cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.1.10.4.2'])&gt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_dispositions_ANS.sch] Erreur de conformit?? CI-SIS : l???entr??e obligatoire FR-Disposition (1.3.6.1.4.1.19376.1.5.3.1.1.10.4.2) doit ??tre pr??sente une ou plusieurs fois [1..*].
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>

   <!--PATTERN S_travailEtAccouchement_ANSV??rification de la conformit?? de la section FR-Travail-et-accouchement (1.2.250.1.213.1.1.2.123)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Travail-et-accouchement (1.2.250.1.213.1.1.2.123)</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.123&#34;]" priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.2.123&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_travailEtAccouchement_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;57074-7&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_travailEtAccouchement_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '57074-7'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_travailEtAccouchement_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>

   <!--PATTERN S_principalMotif-non-code_ANSV??rification de la conformit?? de la section FR-Principal-motif-non-code (1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de la section FR-Principal-motif-non-code (1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1&#34;]"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="../cda:section"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
            [S_principalMotif-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cet ??l??ment ne peut ??tre utilis?? que comme section.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_principalMotif-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cette section doit obligatoirement contenir un ??l??ment 'id' unique.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@code = &#34;10154-3&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_principalMotif-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Le code de cette section doit ??tre '10154-3'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code[@codeSystem = &#34;2.16.840.1.113883.6.1&#34;]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_principalMotif-non-code_ANS.sch] Erreur de conformit?? CI-SIS : L'??l??ment 'codeSystem' doit ??tre cod?? ?? partir de la nomenclature LOINC (2.16.840.1.113883.6.1).
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:text)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [S_principalMotif-non-code_ANS.sch] Erreur de conformit?? CI-SIS : Cette section doit contenir un ??l??ment 'text'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>

   <!--PATTERN E_dispositifMedical-2_ANSV??rification de la conformit?? de l'entr??e FR-Dispositif-medical (1.2.250.1.213.1.1.3.20) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e FR-Dispositif-medical (1.2.250.1.213.1.1.3.20) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.20&#34;]" priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.20&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="self::cda:supply[@classCode='SPLY' and @moodCode='EVN' or 'INT']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Les attributs @classCode et @moodCode de l'??l??ment 'supply' doivent ??tre fix??s respectivement aux valeurs 'SPLY' et 'EVN'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId[@root=&#34;1.2.250.1.213.1.1.3.20&#34;])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e Dispositif m??dical, il doit y avoir un 'templateId' avec un attribut root='1.2.250.1.213.1.1.3.20'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId[@root=&#34;2.16.840.1.113883.10.20.1.34&#34;])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e Dispositif m??dical, il doit y avoir un 'templateId' avec un attribut root='2.16.840.1.113883.10.20.1.34'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:effectiveTime)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e Dispositif m??dical, il doit y avoir un seul (et un seul) 'effectiveTime'. Si la date n???est pas connue, utiliser la valeur nullFlavor="UNK".
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:participant"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e Dispositif m??dical, au moins un ??l??ment 'participant' est obligatoire.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:participant/cda:participantRole[@classCode='MANU'])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e Dispositif m??dical, un (et un seul) ??l??ment 'participant/participantRole' est obligatoire avec un attribut classCode="MANU".
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:participant/cda:participantRole/cda:playingDevice[@classCode='DEV' and @determinerCode='INSTANCE'])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_dispositifMedical-2_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e Dispositif m??dical, il doit y avoir un seul (et un seul) ??l??ment 'participant/participantRole/playingDevice' avec les attributs @classCode et @determinerCode respectivement fix??s aux valeurs 'DEV' et 'INSTANCE'.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>

   <!--PATTERN E_dispositifMedicalComplement_ANSV??rification de la conformit?? de l'entr??e Entr??e Dispositif M??dical ??? compl??ment (1.2.250.1.213.1.1.3.1) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e Entr??e Dispositif M??dical ??? compl??ment (1.2.250.1.213.1.1.3.1) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.1&#34;]" priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.1&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@classCode=&#34;OBS&#34; and @moodCode=&#34;EVN&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : L'??l??ment organizer doit avoir ses attributs fix??s ainsi: classCode="OBS" et moodCode="EVN"
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId[@root=&#34;1.2.250.1.213.1.1.3.1&#34;])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : L'??l??ment organizer doit avoir un ??l??ment templateId avec un attribut root='1.2.250.1.213.1.1.3.1'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId[@root=&#34;1.3.6.1.4.1.19376.1.5.3.1.4.13&#34;])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : L'??l??ment organizer doit avoir un ??l??ment templateId avec un attribut root='1.3.6.1.4.1.19376.1.5.3.1.4.13'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical - Compl??ment" comporte obligatoirement un ??l??ment "id".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:code)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical - Compl??ment" ne doit comporter qu'un seul ??l??ment "code"</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:text/cda:reference)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical - Compl??ment" doit comporter un ??l??ment "text" avec une r??f??rence</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:effectiveTime)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical - Compl??ment" doit comporter un ??l??ment "effectiveTime" pour horodater l'observation</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:statusCode)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical Implant??" comporte obligatoirement un ??l??ment "statutCode" </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
         [E_dispositifMedicalComplement_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical Implant??" comporte obligatoirement un ??l??ment "value" pour donner une valeur ?? l'??l??ment observ?? </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>

   <!--PATTERN E_dispositifMedicalImplante_ANSV??rification de la conformit?? de l'entr??e "Dispositif M??dical Implant??" (1.2.250.1.213.1.1.3.2) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e "Dispositif M??dical Implant??" (1.2.250.1.213.1.1.3.2) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.2&#34;]" priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.2&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@classCode=&#34;CLUSTER&#34; and @moodCode=&#34;EVN&#34;"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalImplante_ANS]: Erreur de conformit?? CI-SIS : L'??l??ment 'organizer' doit comporter les attributs suivants : classCode="CLUSTER" et moodCode="EVN"
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId[@root=&#34;1.2.250.1.213.1.1.3.2&#34;])=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalImplante_ANS]: Erreur de conformit?? CI-SIS : L'??l??ment 'organizer' doit comporter un ??l??ment 'templateId' avec un attribut root='1.2.250.1.213.1.1.3.2'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalImplante_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical Implant??" comporte obligatoirement un ??l??ment "id".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:code)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
         [E_dispositifMedicalImplante_ANS]: Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical Implant??" ne doit comporter qu'un seul ??l??ment "code".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:statusCode)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> 
         [E_dispositifMedicalImplante_ANS] Erreur de conformit?? CI-SIS : Un ??l??ment "Dispositif M??dical Implant??" comporte obligatoirement un ??l??ment "statutCode".
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>

   <!--PATTERN E_enRapportAccidentTravail_ANSCI-SIS Entr??e "FR-En-rapport-avec-accident-travail"-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">CI-SIS Entr??e "FR-En-rapport-avec-accident-travail"</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.14']" priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.14']"/>
      <xsl:variable name="count_valueTrue" select="(count(cda:value[@value='true']))"/>
      <xsl:variable name="count_valueFalse" select="(count(cda:value[@value='false']))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId[@root='1.2.250.1.213.1.1.3.48'] and cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [1] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-accident-travail" doit avoir trois 'templateId' :
                - Un premier 'templateId' dont l'attribut @root="1.3.6.1.4.1.19376.1.5.3.1.4.13"
                - Un deuxi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48"
                - Un troisi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48.14"
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:id)=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [2] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-accident-travail" doit comporter un ??l??ment 'id'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:code[@code='GEN-180'][@codeSystem='1.2.250.1.213.1.1.4.322'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [3] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-accident-travail" doit comporter un ??l??ment 'code' avec les attributs :
                - @code="GEN-180" (cardinalit?? [1..1])
                - @codeSystem="1.2.250.1.213.1.1.4.322" (cardinalit?? [1..1])
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:text/cda:reference)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [4] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-accident-travail" doit comporter un ??l??ment 'text/reference'. 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:statusCode[@code='completed'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [5] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS :  
                L'entr??e "FR-En-rapport-avec-accident-travail" doit comporter un ??l??ment 'statusCode' et son attribut @code="completed". 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:effectiveTime)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [6] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-accident-travail" doit comporter un ??l??ment 'effectiveTime'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(($count_valueTrue=1) or ($count_valueFalse=1)) and count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [7] [E_enRapportAccidentTravail_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-accident-travail" doit comporter un ??l??ment 'value' qui ne peut prendre qu'une des valeurs suivantes :
                - @value="true" : le traitement est prescrit dans le cadre d'un accident du travail
                - @value="false" : le traitement n'est pas prescrit dans le cadre d'un accident du travail
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>

   <!--PATTERN E_enRapportALD_ANSV??rification de la conformit?? de l'entr??e FR-En-rapport-avec-ALD (1.2.250.1.213.1.1.3.48.13) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e FR-En-rapport-avec-ALD (1.2.250.1.213.1.1.3.48.13) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.13']" priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.13']"/>
      <xsl:variable name="count_valueTrue" select="(count(cda:value[@value='true']))"/>
      <xsl:variable name="count_valueFalse" select="(count(cda:value[@value='false']))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId[@root='1.2.250.1.213.1.1.3.48'] and cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [1] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-ALD" doit avoir trois 'templateId' :
                - Un premier 'templateId' dont l'attribut @root="1.3.6.1.4.1.19376.1.5.3.1.4.13" (Conformit?? de l'entr??e au parent IHE PCC)
                - Un deuxi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48" (Conformit?? de l'entr??e au parent CI-SIS)
                - Un troisi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48.13" (Conformit?? de l'entr??e au format CI-SIS)
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [2] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-ALD" doit comporter un ??l??ment 'id'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:code[@code='MED-574'][@codeSystem='1.2.250.1.213.1.1.4.322'][@codeSystemName='TA_ASIP'][@displayName='En rapport avec une ALD'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [3] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-ALD" doit comporter un ??l??ment 'code' avec les attributs :
                - @code="MED-574" (cardinalit?? [1..1])
                - @displayName="En rapport avec une ALD" (cardinalit?? [1..1]) 
                - @codeSystem="1.2.250.1.213.1.1.4.322" (cardinalit?? [1..1])
                - @codeSystemName="TA_ASIP" (cardinalit?? [1..1])
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:text/cda:reference)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [4] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-ALD" doit comporter un ??l??ment 'text/reference'. 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:statusCode[@code='completed'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [5] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS :  
                L'entr??e "FR-En-rapport-avec-ALD" doit comporter un ??l??ment 'statusCode' et son attribut @code="completed". 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:effectiveTime)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [6] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-ALD" doit comporter un ??l??ment 'effectiveTime'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(($count_valueTrue=1) or ($count_valueFalse=1)) and count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [7] [E_enRapportALD_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-En-rapport-avec-ALD" doit comporter un ??l??ment 'value' qui ne peut prendre qu'une des valeurs suivantes :
                - @value="true" : le traitement est prescrit dans le cadre d'une affection longue dur??e (ALD)
                - @value="false" : le traitement n'est pas prescrit dans le cadre d'une affection longue dur??e (ALD)
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>

   <!--PATTERN E_horsAMM_ANSCI-SIS Entr??e FR-Hors-AMM-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">CI-SIS Entr??e FR-Hors-AMM</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.12']" priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.12']"/>
      <xsl:variable name="count_valueTrue" select="(count(cda:value[@value='true']))"/>
      <xsl:variable name="count_valueFalse" select="(count(cda:value[@value='false']))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId[@root='1.2.250.1.213.1.1.3.48'] and cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [1] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Hors-AMM" doit comporter trois 'templateId' :
                - Un premier 'templateId' dont l'attribut @root="1.3.6.1.4.1.19376.1.5.3.1.4.13"
                - Un deuxi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48"
                - Un troisi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48.12"
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:id)=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [2] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Hors-AMM" doit comporter un ??l??ment 'id'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:code[@code='GEN-179'][@codeSystem='1.2.250.1.213.1.1.4.322'][@codeSystemName='TA_ASIP'][@displayName='Hors Autorisation de Mise sur le March?? (AMM)'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [3] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Hors-AMM" doit comporter un ??l??ment 'code' avec les attributs :
                - @code="GEN-179" (cardinalit?? [1..1])
                - @displayName="Hors Autorisation de Mise sur le March?? (AMM)" (cardinalit?? [1..1]) 
                - @codeSystem="1.2.250.1.213.1.1.4.322" (cardinalit?? [1..1])
                - @codeSystemName="TA_ASIP" (cardinalit?? [1..1])
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:text/cda:reference)=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [4] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Hors-AMM" doit comporter un ??l??ment 'text/reference'. 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:statusCode[@code='completed'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [5] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS :  
                L'entr??e "FR-Hors-AMM" doit comporter un ??l??ment 'statusCode' et son attribut @code="completed". 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:effectiveTime)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [6] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Hors-AMM" doit comporter un ??l??ment 'effectiveTime'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(($count_valueTrue=1) or ($count_valueFalse=1)) and count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [7] [E_horsAMM_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Hors-AMM" doit comporter un ??l??ment 'value'qui ne peut prendre qu'une des valeurs suivantes :
                - @value="true" : le traitement prescrit ne poss??de pas d'AMM
                - @value="false" : le traitement prescrit poss??de une AMM
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>

   <!--PATTERN E_nonRemboursable_ANSV??rification de la conformit?? de l'entr??e FR-Non-remboursable (1.2.250.1.213.1.1.3.48.15) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e FR-Non-remboursable (1.2.250.1.213.1.1.3.48.15) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.15']" priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root='1.2.250.1.213.1.1.3.48.15']"/>
      <xsl:variable name="count_valueTrue" select="(count(cda:value[@value='true']))"/>
      <xsl:variable name="count_valueFalse" select="(count(cda:value[@value='false']))"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId[@root='1.2.250.1.213.1.1.3.48'] and cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.4.13']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [1] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Non-remboursable" doit avoir trois occurrences de 'templateId' :
                - Un premier 'templateId' dont l'attribut @root="1.3.6.1.4.1.19376.1.5.3.1.4.13"
                - Un deuxi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48"
                - Un troisi??me 'templateId' dont l'attribut @root="1.2.250.1.213.1.1.3.48.15"
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:id)=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [2] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Non-remboursable" doit comporter un ??l??ment 'id'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:code[@code='GEN-181'][@codeSystem='1.2.250.1.213.1.1.4.322'][@codeSystemName='TA_ASIP'][@displayName='Non remboursable'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [3] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Non-remboursable" doit comporter un ??l??ment 'code' avec les attributs :
                - @code="GEN-181" (cardinalit?? [1..1])
                - @displayName="Non remboursable" (cardinalit?? [1..1]) 
                - @codeSystem="1.2.250.1.213.1.1.4.322" (cardinalit?? [1..1])
                - @codeSystemName="TA_ASIP" (cardinalit?? [1..1])
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:text/cda:reference)=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [4] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Non-remboursable" doit comporter un ??l??ment 'text/reference'. 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:statusCode[@code='completed'])=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [5] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS :  
                L'entr??e "FR-Non-remboursable" doit comporter un ??l??ment 'statusCode' avec un attribut @code="completed". 
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(count(cda:effectiveTime)=1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [6] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Non-remboursable" doit comporter un ??l??ment 'effectiveTime'.
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(($count_valueTrue=1) or ($count_valueFalse=1)) and count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [7] [E_nonRemboursable_ANS.sch] Erreur de conformit?? CI-SIS : 
                L'entr??e "FR-Non-remboursable" doit comporter un ??l??ment 'value'. L'attribut @value ne peut prendre qu'une des valeurs suivantes :
                - @value="true" : le traitement prescrit n'est pas remboursable
                - @value="false" : le traitement prescrit est remboursable
            </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>

   <!--PATTERN E_observationNIHSSComponent_ANSV??rification de la conformit?? de l'entr??e FR-Composant-score-NIHSS (1.2.250.1.213.1.1.3.8) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e FR-Composant-score-NIHSS (1.2.250.1.213.1.1.3.8) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.8&#34;]" priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.8&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="self::cda:observation[@classCode='OBS' and @moodCode='EVN']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, les attributs @classCode, @moodCode de l'??l??ment observation sont fix??s resectivement aux valeurs 'OBS', 'EVN' </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, il doit y avoir un ??l??ment id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId)&gt;2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, il doit y avoir au minimum trois templateId
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, il doit y avoir le template Id de la simple observation (???1.3.6.1.4.1.19376.1.5.3.1.4.13???)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId/@root='2.16.840.1.113883.10.20.1.31'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, Il doit y avoir le templateId/@root='2.16.840.1.113883.10.20.1.31'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:statusCode/@code='completed'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, le statusCode doit pr??sent et fix?? ?? la valeur @code='completed'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:effectiveTime"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, un ??l??ment effectiveTime doit ??tre pr??sent 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, il doit y avoir un ??l??ment value (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:interpretationCode)&lt;=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
           [E_observationNIHSSComponent_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Composant-score-NIHSS, il peut y avoir un interpretationCode (cardinalit?? [0..1])
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>

   <!--PATTERN E_observationScoreNIHSS_ANSV??rification de la conformit?? de l'entr??e FR-Score-NIHSS (1.2.250.1.213.1.1.3.6) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e FR-Score-NIHSS (1.2.250.1.213.1.1.3.6) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.6&#34;]" priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.6&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="self::cda:observation[@classCode='OBS' and @moodCode='EVN' and @negationInd='false']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, les attributs @classCode, @moodCode et @negationInd de l'??l??ment observation sont fix??s resectivement aux valeurs 'OBS', 'EVN' et 'false'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, il doit y avoir un ??l??ment id (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:templateId)=3"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, il doit y avoir trois templateId (crdinalit?? [3..3])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, il doit y avoir le template Id de la simple observation (???1.3.6.1.4.1.19376.1.5.3.1.4.13???)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:templateId/@root='2.16.840.1.113883.10.20.1.31'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, Il doit y avoir le templateId/@root='2.16.840.1.113883.10.20.1.31'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:statusCode/@code='completed'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, le statusCode doit pr??sent et fix?? ?? la valeur @code='completed'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:effectiveTime"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, un ??l??ment effectiveTime doit ??tre pr??sent 
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:value)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, il doit y avoir un ??l??ment value (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not(cda:entryRelationship) or cda:entryRelationship/cda:observation/cda:templateId/@root='1.2.250.1.213.1.1.3.8'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_observationScoreNIHSS_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Score-NIHSS, il ne peut y avoir que des observations NIHSS Component entry (1.2.250.1.213.1.1.3.8)
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>

   <!--PATTERN E_organizerDocumentAttache_ANSASIP Sant?? organizer RCP -->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">ASIP Sant?? organizer RCP </svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.3.18&#34;]" priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root = &#34;1.2.250.1.213.1.1.3.18&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="self::cda:organizer[@classCode = 'CLUSTER' and @moodCode = 'EVN']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerDocumentAttache_ANS.sch] Erreur de conformit?? CI-SIS : Dansl'entr??e FR-Document-attache, les attributs @classCode et @moodCode de l'??l??ment
            observation sont fix??s resectivement aux valeurs 'CLUSTER' et 'EVN'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:id) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerDocumentAttache_ANS.sch] Erreur de conformit?? CI-SIS : Dansl'entr??e FR-Document-attache, il doit y avoir un ??l??ment 'id' (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [[E_organizerDocumentAttache_ANS.sch] Erreur de conformit?? CI-SIS : Dansl'entr??e FR-Document-attache, l'??l??ment code doit ??tre pr??sent.
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:statusCode/@code = 'completed'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerDocumentAttache_ANS.sch] Erreur de conformit?? CI-SIS : Dansl'entr??e FR-Document-attache, le 'statusCode' doit pr??sent et fix?? ?? la valeur @code='Completed'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:component/cda:observation/cda:templateId/@root = '1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerDocumentAttache_ANS.sch] Erreur de conformit?? CI-SIS : Dansl'entr??e FR-Document-attache,il doit y avoir au moins une simple observation
            (templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13')
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:component/cda:observationMedia[@classCode = 'OBS' and @moodCode = 'EVN']/cda:value[@mediaType and @representation = 'B64']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerDocumentAttache_ANS.sch] Erreur de conformit?? CI-SIS : Dansl'entr??e FR-Document-attache, il doit y avoir au moins un observation media, contenant
            une value dont le XPath est le suivant :
            cda:component/cda:observationMedia[@classCode='OBS' and
            @moodCode='EVN']/cda:value[@mediaType='text/xml' and @representation='B64']
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>

   <!--PATTERN E_organizerRCP_ANSV??rification de la conformit?? de l'entr??e FR-Statut-du-dossier-presente-en-RCP (1.2.250.1.213.1.1.3.7) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e FR-Statut-du-dossier-presente-en-RCP (1.2.250.1.213.1.1.3.7) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.7&#34;]" priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.7&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="self::cda:organizer[@classCode='CLUSTER' and @moodCode='EVN']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerRCP_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Statut-du-dossier-presente-en-RCP, les attributs @classCode et @moodCode de l'??l??ment observation sont fix??s resectivement aux valeurs 'CLUSTER' et 'EVN'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerRCP_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Statut-du-dossier-presente-en-RCP, l'??l??ment code doit ??tre pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:statusCode/@code='completed'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerRCP_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Statut-du-dossier-presente-en-RCP, le statusCode doit pr??sent et fix?? ?? la valeur @code='completed'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:component/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerRCP_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'entr??e FR-Statut-du-dossier-presente-en-RCP, il doit y avoir au moins une simple observation (templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13')
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>

   <!--PATTERN E_organizerTraitementInitialAVC_ANSV??rification de la conformit?? de l'entr??e Traitement initial AVC (1.2.250.1.213.1.1.3.16) cr????e par l'ANS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">V??rification de la conformit?? de l'entr??e Traitement initial AVC (1.2.250.1.213.1.1.3.16) cr????e par l'ANS</svrl:text>

	  <!--RULE -->
<xsl:template match="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.16&#34;]" priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[cda:templateId/@root=&#34;1.2.250.1.213.1.1.3.16&#34;]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="self::cda:organizer[@classCode='BATTERY' and @moodCode='EVN']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerTraitementInitialAVC_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'organizer traitement initial AVC, les attributs @classCode et @moodCode de l'??l??ment observation sont fix??s resectivement aux valeurs 'BATTERY' et 'EVN'</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:code"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerTraitementInitialAVC_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'organizer traitement initial AVC, l'??l??ment code doit ??tre pr??sent
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:statusCode/@code='completed'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerTraitementInitialAVC_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'organizer traitement initial AVC, le statusCode doit pr??sent et fix?? ?? la valeur @code='completed'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(cda:author)=1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerTraitementInitialAVC_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'organizer traitement initial AVC, il doit y avoir un ??l??ment author (cardinalit?? [1..1])
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="cda:component/cda:observation/cda:templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [E_organizerTraitementInitialAVC_ANS.sch] Erreur de conformit?? CI-SIS : Dans l'organizer traitement initial AVC, il doit y avoir au moins une simple observation (templateId/@root='1.3.6.1.4.1.19376.1.5.3.1.4.13')
       </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>
</xsl:stylesheet>