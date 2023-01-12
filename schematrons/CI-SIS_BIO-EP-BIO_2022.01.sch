<?xml version="1.0" encoding="UTF-8"?>
<!-- CI-SIS_BIO-EP-BIO_2022.01.sch 
     ......................................................................................................................................................
     Vérification de la conformité au modèle du document Bio-eP-BIO_2022.01 du CI-SIS.
     ......................................................................................................................................................
     Historique :
        - 11/07/2022 : Création
-->

<schema xmlns="http://purl.oclc.org/dsdl/schematron" defaultPhase="BIO-EP-BIO_2022.01"
    xmlns:cda="urn:hl7-org:v3" queryBinding="xslt2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" schemaVersion="BIO-EP-BIO_2022.01.sch">
    
    <title>Rapport de conformité du document aux spécifications du modèle de document Bio-eP-BIO_2022.01 (Prescriction d'actes de biologie médicale)</title>
    
    <ns prefix="cda" uri="urn:hl7-org:v3"/>
    <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <ns prefix="jdv" uri="http://esante.gouv.fr"/>
    <ns prefix="svs" uri="urn:ihe:iti:svs:2008"/>
    
    <!-- Abstract patterns -->
    <include href="abstract/dansJeuDeValeurs.sch"/> 
    <include href="abstract/IVL_TS.sch"/>
    
    <!-- Entête du document BIO-EP-BIO -->
    <include href="include/specificationsVolets/BIO-EP-BIO_2022.01/Entete/Entete_BIO-EP-BIO_2022.01.sch"/>
    
    <!-- Phase en vigueur -->
    <phase id="BIO-EP-BIO_2022.01">
        <active pattern="variables"/>
        <active pattern="Entete_BIO-EP-BIO_2022.01"/>
    </phase>
    
    <!-- Variables globales -->
    <pattern id="variables">
        <rule context="cda:ClinicalDocument[cda:templateId[@root='1.2.250.1.213.1.1.1.51']]/cda:component/cda:structuredBody">
            <assert test="cda:component/cda:section/cda:templateId[@root='1.2.250.1.213.1.1.2.158.2']">
                [BIO-EP-BIO_2022.01] Erreur de conformité : La section "FR-Plan-de-soins-biologie" (1.2.250.1.213.1.1.2.158.2) doit être présente.
            </assert>
            <assert test="not(cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:title) or cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:title='Actes de biologie médicales prescrits'">
                [BIO-EP-BIO_2022.01] Erreur de conformité : Le titre de la section FR-Plan-de-soins-biologie prend la valeur "Actes de biologie médicales prescrits" si il est présent
            </assert>
            <assert test="cda:component/cda:section/cda:templateId[@root='1.2.250.1.213.1.1.2.223']"> 
                [BIO-EP-BIO_2022.01] Erreur de conformité : La section "FR-Code-a-barres" (1.2.250.1.213.1.1.2.223) doit être présente.
            </assert> 
            <assert test="count(cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.223']/cda:entry/cda:observationMedia[cda:templateId/@root='1.2.250.1.213.1.1.3.103'])=1"> 
                [BIO-EP-BIO_2022.01] Erreur de conformité : L'entrée FR-Image-illustrative (1.2.250.1.213.1.1.3.103) du code 2D est obligatoire de cardinalité 1..1
            </assert> 
            <assert test="not(cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.223']/cda:title='Code 2D de la prescription') or cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.223']/cda:title='Code 2D de la prescription'">
                [BIO-EP-BIO_2022.01] Erreur de conformité : Le titre de la section FR-Code-a-barres prend la valeur "Code 2D de la prescription" si il est présent
            </assert>
            <assert test="cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:entry/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.27.2']/cda:code[@codeSystem='2.16.840.1.113883.6.1']">
                [BIO-EP-BIO_2022.01] Erreur de conformité : L'élément code de l'entrée "FR-Acte-biologie-prescrit" (1.2.250.1.213.1.1.3.27.2) doit être un code LOINC.
            </assert>
            <!--<assert test="cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:entry/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.27.2']">
                [BIO-EP-BIO_2022.01] Erreur de conformité : L'entrée "FR-Acte-biologie-prescrit" (1.2.250.1.213.1.1.3.27.2) est obligatoire.
            </assert>-->
        </rule>
        <rule context="cda:ClinicalDocument[cda:templateId/@root='1.2.250.1.213.1.1.1.51']">
            <assert test="(//cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:entry/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.27.2']/cda:priorityCode[@code='UR'] and //cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:code[@code='MED-1095']) or (not(//cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:entry/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.27.2']/cda:priorityCode[@code='UR']) and not(//cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:code[@code='MED-1095']))">
                [BIO-EP-BIO_2022.01] Erreur de conformité : Si une entrée Fr-Acte-biologie-prescrit contient un code "UR" alors la prescription doit avoir un sous-statut "MED-1095"
            </assert>
            <assert test="(//cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:entry/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.27.2']/cda:entryRelationship/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.48.13']/cda:value[@value='true'] and //cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:code[@code='MED-1096']) or (not(//cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section[cda:templateId/@root='1.2.250.1.213.1.1.2.158.2']/cda:entry/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.27.2']/cda:entryRelationship/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.48.13']/cda:value[@value='true']) and not(//cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:code[@code='MED-1096']))">
                [BIO-EP-BIO_2022.01] Erreur de conformité : Si une entrée Fr-Acte-biologie-prescrit contient une Entrée FR-En-rapport-avec-ALD avec une valeur TRUE alors le sous-type de prescription doit prendre la valeur:@code="MED-1096"
            </assert>
        </rule>
    </pattern> 
</schema>

