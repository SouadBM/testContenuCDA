<?xml version="1.0" encoding="UTF-8"?>

<!-- CI-SIS_IPS-FR_2022.01.sch
        
        CI-SIS - Schématron de la Synthèse médicale (IPS-FR_2022.01)
        Auteur : ANS 
        Historique :
        10/03/2022 : Création 
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" defaultPhase="CI-SIS_IPS-FR_2022.01"
        xmlns:cda="urn:hl7-org:v3" queryBinding="xslt2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        schemaVersion="CI-SIS_IPS-FR_2022.01.sch">

        <title>Rapport de conformité du document aux spécifications du volet IPS-FR_2022.01</title>
        <ns prefix="cda" uri="urn:hl7-org:v3"/>
        <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <ns prefix="jdv" uri="http://esante.gouv.fr"/>
        <ns prefix="svs" uri="urn:ihe:iti:svs:2008"/>

        <!--  Abstract patterns  -->
        <include href="abstract/dansJeuDeValeurs.sch"/>
        <include href="abstract/IVL_TS.sch"/>
        

        <phase id="CI-SIS_IPS-FR_2022.01">
                <active pattern="variables"/>
                <p>Vérification de la conformité au CI-SIS</p>
        </phase>

        <pattern id="variables">

                <rule context="cda:ClinicalDocument/cda:component/cda:structuredBody">
                        
                        <!--  Verifier la présence de la section FR-Traitements -->
                        <assert test="cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.3.19']"> 
                                [IPS-FR_2022.01] Erreur de conformité : La section FR-Traitements (1.3.6.1.4.1.19376.1.5.3.1.3.19) doit être présente.
                        </assert>
                        
                        <!--  Verifier la présence de la section FR-Allergies-et-intolerances -->
                        <assert test="cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.3.13']"> 
                                [IPS-FR_2022.01] Erreur de conformité : La section FR-Allergies-et-intolerances (1.3.6.1.4.1.19376.1.5.3.1.3.13) doit être présente. 
                        </assert>
                        
                        <!-- Vérifier la présence de la section FR-Problemes-actifs -->
                        <assert test="cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.3.6']"> 
                                [IPS-FR_2022.01] Erreur de conformité : La section FR-Problemes-actifs (1.3.6.1.4.1.19376.1.5.3.1.3.6) doit être présente. 
                        </assert>
                        
                        <!-- Vérifier la présence de la section FR-Antecedents-chirurgicaux -->
                        <assert test="cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.3.11']"> 
                                [IPS-FR_2022.01] Erreur de conformité : La section FR-Antecedents-chirurgicaux (1.3.6.1.4.1.19376.1.5.3.1.3.11) doit être présente. 
                        </assert>
                        
                        <!-- Vérifier la présence de la section FR-Dispositifs-medicaux -->
                        <assert test="cda:component/cda:section/cda:templateId[@root = '1.3.6.1.4.1.19376.1.5.3.1.1.5.3.5']"> 
                                [IPS-FR_2022.01] Erreur de conformité : La section FR-Dispositifs-medicaux (1.3.6.1.4.1.19376.1.5.3.1.1.5.3.5) doit être présente. 
                        </assert>

                </rule>
        </pattern>
</schema>
