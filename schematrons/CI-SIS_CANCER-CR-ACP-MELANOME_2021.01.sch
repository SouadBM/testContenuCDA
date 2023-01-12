<?xml version="1.0" encoding="UTF-8"?>

<!-- Schématron CI-SIS_CANCER-CR-ACP-MELANOME_2021.01
        Vérification de la conformité du document au modèle CANCER-CR-ACP-MELANOME_2021.01   
        
        Auteur : ANS 
        Historique :
        17/03/2021 : Création
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" defaultPhase="CANCER-CR-ACP-MELANOME"
        xmlns:cda="urn:hl7-org:v3" queryBinding="xslt2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" schemaVersion="CI-SIS_CANCER-CR-ACP-MELANOME_2021.01.sch">

        <title>Vérification de la conformité du document au modèle CANCER-CR-ACP-MELANOME_2021.01</title>
        <ns prefix="cda" uri="urn:hl7-org:v3"/>
        <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <ns prefix="jdv" uri="http://esante.gouv.fr"/>
        <ns prefix="svs" uri="urn:ihe:iti:svs:2008"/>
        <!--  Abstract patterns  -->
        <include href="abstract/dansJeuDeValeurs.sch"/>
        <include href="abstract/IVL_TS.sch"/>
        <!-- JDV du document CR-ACP-MELANOME -->
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_TypePrelevement_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Localisation_Region_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Etat_Piece_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Fixateur_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Type_histologique_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Niveau_Invasion_Clark_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Regression_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Ulceration_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Microsatellite_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Neurotropisme_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Emboles_Lymphovasculaires_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Evaluation_TILs_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Diagnostic_En_Attente_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Type_Limites_Laterales_Envahies_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Type_Limite_Profonde_Envahie_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Diagnostic_Melanome_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Diagnostic_Etat_Ganglions_Melanome_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_Examen_MetastaseADistance_Melanome_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_PT_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_PN_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_PM_Melanome-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-MELANOME_2021.01/JDV_StatutR_Melanome_CISIS.sch"/>

        <phase id="CANCER-CR-ACP-MELANOME">
                <active pattern="variables"/>
                <p>Vérification complète de la conformité au CI-SIS</p>
                <!-- schématrons des JDV CR-ACP-MELANOME -->
                <active pattern="JDV_TypePrelevement_Melanome-CISIS"/>
                <active pattern="JDV_Localisation_Region_Melanome-CISIS"/>
                <active pattern="JDV_Etat_Piece_Melanome-CISIS"/>
                <active pattern="JDV_Fixateur_Melanome-CISIS"/>
                <active pattern="JDV_Type_histologique_Melanome-CISIS"/>
                <active pattern="JDV_Niveau_Invasion_Clark_Melanome-CISIS"/>
                <active pattern="JDV_Regression_Melanome-CISIS"/>
                <active pattern="JDV_Ulceration_Melanome-CISIS"/>
                <active pattern="JDV_Microsatellite_Melanome-CISIS"/>
                <active pattern="JDV_Neurotropisme_Melanome-CISIS"/>                
                <active pattern="JDV_Emboles_Lymphovasculaires_Melanome-CISIS"/>
                <active pattern="JDV_Evaluation_TILs_Melanome-CISIS"/>
                <active pattern="JDV_Diagnostic_En_Attente_Melanome-CISIS"/>
                <active pattern="JDV_Type_Limites_Laterales_Envahies_Melanome-CISIS"/>
                <active pattern="JDV_Type_Limite_Profonde_Envahie_Melanome-CISIS"/>
                <active pattern="JDV_Diagnostic_Melanome_CISIS"/>
                <active pattern="JDV_Diagnostic_Etat_Ganglions_Melanome_CISIS"/>
                <active pattern="JDV_Examen_MetastaseADistance_Melanome_CISIS"/>
                <active pattern="JDV_PT_Melanome-CISIS"/>
                <active pattern="JDV_PN_Melanome-CISIS"/>
                <active pattern="JDV_PM_Melanome-CISIS"/>
                <active pattern="JDV_StatutR_Melanome_CISIS"/>
        </phase>
        <pattern id="variables">      
                <let name="jdv_TypePrelevement_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_TypePrelevement_Melanome-CISIS.xml'"/>
                <let name="jdv_Localisation_Region_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Localisation_Region_Melanome-CISIS.xml'"/>
                <let name="jdv_Etat_Piece_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_PrelevementEtatPiece_CISIS.xml'"/>
                <let name="jdv_Fixateur_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_PrelevementFixateur-CISIS.xml'"/>
                <let name="jdv_Type_histologique_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Type_histologique_Melanome-CISIS.xml'"/>
                <let name="jdv_Niveau_Invasion_Clark_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Niveau_Invasion_Clark_Melanome-CISIS.xml'"/>
                <let name="jdv_Regression_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Regression_Melanome-CISIS.xml'"/>
                <let name="jdv_Ulceration_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Ulceration_Melanome-CISIS.xml'"/>
                <let name="jdv_Microsatellite_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Microsatellite_Melanome-CISIS.xml'"/>
                <let name="jdv_Neurotropisme_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Neurotropisme_Melanome-CISIS.xml'"/>
                <let name="jdv_Emboles_Lymphovasculaires_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Neurotropisme_Melanome-CISIS.xml'"/>                
                <let name="jdv_Evaluation_TILs_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Evaluation_TILs_Melanome-CISIS.xml'"/>
                <let name="jdv_Diagnostic_En_Attente_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Diagnostic_En_Attente_Melanome-CISIS.xml'"/>
                <let name="jdv_Type_Limites_Laterales_Envahies_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Type_Limites_Laterales_Envahies_Melanome-CISIS.xml'"/>
                <let name="jdv_Type_Limite_Profonde_Envahie_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_Type_Limite_Profonde_Envahie_Melanome-CISIS.xml'"/>
                <let name="jdv_Diagnostic_Melanome_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretDescriptionHistologique_CISIS.xml'"/>
                <let name="jdv_Diagnostic_Etat_Ganglions_Melanome_CISIS" value="'../jeuxDeValeurs/JDV_Diagnostic_Etat_Ganglions_Melanome_CISIS.xml'"/>
                <let name="jdv_Examen_MetastaseADistance_Melanome_CISIS" value="'../jeuxDeValeurs/JDV_Examen_MetastaseADistance_CISIS.xml'"/>
                <let name="jdv_PT_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_PT_Melanome-CISIS.xml'"/>
                <let name="jdv_PN_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_PN_Melanome-CISIS.xml'"/>
                <let name="jdv_PM_Melanome-CISIS" value="'../jeuxDeValeurs/JDV_PM_Melanome-CISIS.xml'"/>
                <let name="jdv_StatutR_Melanome_CISIS" value="'../jeuxDeValeurs/JDV_Examen_StatutR_CISIS.xml'"/>
                
                <rule context="cda:ClinicalDocument/cda:component/cda:structuredBody">
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.6']"> 
                                [CANCER-CR-ACP-MELANOME_2021.01] Erreur de conformité : La section "Prélèvement" (1.3.6.1.4.1.19376.1.8.1.2.6) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.3']"> 
                                [CANCER-CR-ACP-MELANOME_2021.01] Erreur de conformité : La section "Examen macroscopique" (1.3.6.1.4.1.19376.1.8.1.2.3) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.4']"> 
                                [CANCER-CR-ACP-MELANOME_2021.01] Erreur de conformité : La section "Examen microscopique" (1.3.6.1.4.1.19376.1.8.1.2.4) doit être présente.
                        </assert>
                </rule>
        </pattern>
</schema>