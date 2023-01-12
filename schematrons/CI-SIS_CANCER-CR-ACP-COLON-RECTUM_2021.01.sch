<?xml version="1.0" encoding="UTF-8"?>

<!-- Schématron CI-SIS_CANCER-CR-ACP-COLON-RECTUM_2021.01
     Vérification de la conformité du document au modèle CANCER-CR-ACP-COLON-RECTUM_2021.01   
        
        Auteur : ANS 
        Historique :
        17/03/2021 : Création
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" defaultPhase="CANCER-CR-ACP-COLON-RECTUM"
        xmlns:cda="urn:hl7-org:v3" queryBinding="xslt2"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
        xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
        schemaVersion="CI-SIS_CANCER-CR-ACP-COLON-RECTUM_2021.01.sch">

        <title>Vérification de la conformité du document au modèle CANCER-CR-ACP_2021.01</title>
        <ns prefix="cda" uri="urn:hl7-org:v3"/>
        <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
        <ns prefix="jdv" uri="http://esante.gouv.fr"/>
        <ns prefix="svs" uri="urn:ihe:iti:svs:2008"/>
        <ns prefix="sqf" uri="http://www.schematron-quickfix.com/validator/process"/>

        <!--  Abstract patterns  -->
        <include href="abstract/dansJeuDeValeurs.sch"/>
        <include href="abstract/IVL_TS.sch"/>
        
        <!-- JDV -->
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretDescriptionHistologique_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_Examen_StatutR_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieLocalisationTumeurRectale_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieAspectTumeur_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieLocalisationTumeur_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_Examen_MetastaseADistance_Localisation_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_Examen_MetastaseADistance_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_Examen_EtatGanglionsLymphatiquesLocoregionaux_Diagnostic_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_Examen_AutreConstatation_ExamenMicroscopique_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenZoneInteretDemandeTechniqueComplementaire_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretReponseTraitementPreOperatoire_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretMargelongitudinale_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretMargeCirconferentielle_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretInvasionPerinerveuse_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretInvasionVasculaire_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretCategorie_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretBourgeonnementTumoral_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretNiveauInfiltration_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretGradeHistologique_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueZoneInteretTypeHistologique_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieZoneInteretIntegriteMesorectum_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieZoneInteretIntegriteMesocolon_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieZoneInteretPerforation_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieLocalisationZoneInteretRectale_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieCirconferenceZoneInteret_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieAspectZoneInteret_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieLocalisationZoneInteret_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurReponseTraitementPreOperatoire_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurMargelongitudinale_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurMargeCirconferentielle_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurInvasionPerinerveuse_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurInvasionVasculaire_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurCategorie_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurBourgeonnementTumoral_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurNiveauInfiltration_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueGradeHistologique_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMicroscopiqueTumeurTypeHistologique_CISIS.sch"/>
        <!--<include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieTumeurIntegriteMesorectum_CISIS.sch"/>-->
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieTumeurIntegriteMesocolon_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieTumeurPerforation_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopieCirconferenceTumeur_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_ExamenMacroscopiePeritoine_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_PrelevementAppendice_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_PrelevementEtatPiece_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_PrelevementFixateur-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_TypePrelevement-CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_Examen_Diagnostic_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_TNM_pTNM_pT_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_TNM_pTNM_pN_CISIS.sch"/>
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_TNM_pTNM_pM_CISIS.sch"/><!--
        <include href="include/jeuxDeValeurs/CANCER-CR-ACP-COLON-RECTUM_2021.01/JDV_TNM_yrpTNM_yrpM_CISIS.sch"/>-->
       
               
        <phase id="CANCER-CR-ACP-COLON-RECTUM">
                <active pattern="variables"/>
                <p>Vérification complète de la conformité au CI-SIS</p>
                
                <!-- schématrons des JDV CR-ACP -->
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretDescriptionHistologique_CISIS"/>
                <active pattern="JDV_Examen_StatutR_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieLocalisationTumeurRectale_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieAspectTumeur_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieLocalisationTumeur_CISIS"/>
                <active pattern="JDV_Examen_MetastaseADistance_Localisation_CISIS"/>
                <active pattern="JDV_Examen_MetastaseADistance_CISIS"/>
                <active pattern="JDV_Examen_EtatGanglionsLymphatiquesLocoregionaux_Diagnostic_CISIS"/>
                <active pattern="JDV_Examen_AutreConstatation_ExamenMicroscopique_CISIS"/>
                <active pattern="JDV_ExamenZoneInteretDemandeTechniqueComplementaire_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretReponseTraitementPreOperatoire_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretMargelongitudinale_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretMargeCirconferentielle_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretInvasionPerinerveuse_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretInvasionVasculaire_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretCategorie_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretBourgeonnementTumoral_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretNiveauInfiltration_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretGradeHistologique_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueZoneInteretTypeHistologique_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieZoneInteretIntegriteMesorectum_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieZoneInteretIntegriteMesocolon_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieZoneInteretPerforation_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieLocalisationZoneInteretRectale_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieCirconferenceZoneInteret_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieAspectZoneInteret_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieLocalisationZoneInteret_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurReponseTraitementPreOperatoire_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurMargelongitudinale_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurMargeCirconferentielle_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurInvasionPerinerveuse_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurInvasionVasculaire_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurCategorie_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurBourgeonnementTumoral_CISIS"/>
                <active pattern="JDV_ExamenMicroscopiqueTumeurNiveauInfiltration_CISIS"/> 
                <active pattern="JDV_ExamenMicroscopiqueGradeHistologique_CISIS"/> 
                <active pattern="JDV_ExamenMicroscopiqueTumeurTypeHistologique_CISIS"/>
                <!--<active pattern="JDV_ExamenMacroscopieTumeurIntegriteMesorectum_CISIS"/>-->
                <active pattern="JDV_ExamenMacroscopieTumeurIntegriteMesocolon_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieTumeurPerforation_CISIS"/>
                <active pattern="JDV_ExamenMacroscopieCirconferenceTumeur_CISIS"/> 
                <active pattern="JDV_ExamenMacroscopiePeritoine_CISIS"/> 
                <active pattern="JDV_PrelevementAppendice_CISIS"/> 
                <active pattern="JDV_PrelevementEtatPiece_CISIS"/>
                <active pattern="JDV_PrelevementFixateur-CISIS"/>
                <active pattern="JDV_TypePrelevement-CISIS"/>
                <active pattern="JDV_Examen_Diagnostic_CISIS"/>
                <active pattern="JDV_TNM_pTNM_pT_CISIS"/>
                <active pattern="JDV_TNM_pTNM_pN_CISIS"/>
                <active pattern="JDV_TNM_pTNM_pM_CISIS"/><!--
                <active pattern="JDV_TNM_yrpTNM_yrpM_CISIS"/>-->
        </phase>
        
        <pattern id="variables">      
                <let name="jdv_ExamenMicroscopiqueZoneInteretDescriptionHistologique_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretDescriptionHistologique_CISIS.xml'"/>
                <let name="jdv_Examen_StatutR_CISIS" value="'../jeuxDeValeurs/JDV_Examen_StatutR_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieLocalisationTumeurRectale_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieLocalisationTumeurRectale_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieAspectTumeur_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieAspectTumeur_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieLocalisationTumeur_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieLocalisationTumeur_CISIS.xml'"/>
                <let name="jdv_Examen_MetastaseADistance_Localisation_CISIS" value="'../jeuxDeValeurs/JDV_Examen_MetastaseADistance_Localisation_CISIS.xml'"/>
                <let name="jdv_Examen_MetastaseADistance_CISIS" value="'../jeuxDeValeurs/JDV_Examen_MetastaseADistance_CISIS.xml'"/>
                <let name="jdv_Examen_EtatGanglionsLymphatiquesLocoregionaux_Diagnostic_CISIS" value="'../jeuxDeValeurs/JDV_Examen_EtatGanglionsLymphatiquesLocoregionaux_Diagnostic_CISIS.xml'"/>
                <let name="jdv_Examen_AutreConstatation_ExamenMicroscopique_CISIS" value="'../jeuxDeValeurs/JDV_Examen_AutreConstatation_ExamenMicroscopique_CISIS.xml'"/>
                <let name="jdv_ExamenZoneInteretDemandeTechniqueComplementaire_CISIS" value="'../jeuxDeValeurs/JDV_ExamenZoneInteretDemandeTechniqueComplementaire_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretReponseTraitementPreOperatoire_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretReponseTraitementPreOperatoire_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretMargelongitudinale_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretMargelongitudinale_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretMargeCirconferentielle_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretMargeCirconferentielle_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretInvasionPerinerveuse_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretInvasionPerinerveuse_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretInvasionVasculaire_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretInvasionVasculaire_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretCategorie_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretCategorie_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretBourgeonnementTumoral_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretBourgeonnementTumoral_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretNiveauInfiltration_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretNiveauInfiltration_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretGradeHistologique_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueZoneInteretGradeHistologique_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueZoneInteretTypeHistologique_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurTypeHistologique_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieZoneInteretIntegriteMesorectum_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieZoneInteretIntegriteMesorectum_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieZoneInteretIntegriteMesocolon_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieZoneInteretIntegriteMesocolon_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieZoneInteretPerforation_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieZoneInteretPerforation_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieLocalisationZoneInteretRectale_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieLocalisationZoneInteretRectale_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieCirconferenceZoneInteret_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieCirconferenceZoneInteret_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieAspectZoneInteret_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieAspectZoneInteret_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieLocalisationZoneInteret_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieLocalisationZoneInteret_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurReponseTraitementPreOperatoire_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurReponseTraitementPreOperatoire_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurMargelongitudinale_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurMargelongitudinale_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurMargeCirconferentielle_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurMargeCirconferentielle_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurInvasionPerinerveuse_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurInvasionPerinerveuse_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurInvasionVasculaire_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurInvasionVasculaire_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurCategorie_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurCategorie_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurBourgeonnementTumoral_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurBourgeonnementTumoral_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurNiveauInfiltration_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurNiveauInfiltration_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueGradeHistologique_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueGradeHistologique_CISIS.xml'"/>
                <let name="jdv_ExamenMicroscopiqueTumeurTypeHistologique_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMicroscopiqueTumeurTypeHistologique_CISIS.xml'"/>
                <!--<let name="jdv_ExamenMacroscopieTumeurIntegriteMesorectum_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieTumeurIntegriteMesorectum_CISIS.xml'"/>-->
                <let name="jdv_ExamenMacroscopieTumeurIntegriteMesocolon_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieTumeurIntegriteMesocolon_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieTumeurPerforation_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieTumeurPerforation_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopieCirconferenceTumeur_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopieCirconferenceTumeur_CISIS.xml'"/>
                <let name="jdv_ExamenMacroscopiePeritoine_CISIS" value="'../jeuxDeValeurs/JDV_ExamenMacroscopiePeritoine_CISIS.xml'"/>
                <let name="jdv_PrelevementAppendice_CISIS" value="'../jeuxDeValeurs/JDV_PrelevementAppendice_CISIS.xml'"/>
                <let name="jdv_PrelevementEtatPiece_CISIS" value="'../jeuxDeValeurs/JDV_PrelevementEtatPiece_CISIS.xml'"/>
                <let name="jdv_PrelevementFixateur-CISIS" value="'../jeuxDeValeurs/JDV_PrelevementFixateur-CISIS.xml'"/>
                <let name="jdv_TypePrelevement-CISIS" value="'../jeuxDeValeurs/JDV_TypePrelevement-CISIS.xml'"/>
                <let name="jdv_Examen_Diagnostic_CISIS" value="'../jeuxDeValeurs/JDV_Examen_EtatGanglionsLymphatiquesLocoregionaux_Diagnostic_CISIS.xml'"/>
                <!--<let name="jdv_TNM_yrpTNM_yrpM_CISIS" value="'../jeuxDeValeurs/JDV_TNM_yrpTNM_yrpM_CISIS.xml'"/>-->
                <let name="jdv_TNM_pTNM_pT_CISIS" value="
                        if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='C3868']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pT_1_CISIS.xml' 
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='MED-715']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pT_2_CISIS.xml'
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='MED-718']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pT_3_CISIS.xml'
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation
                        [cda:templateId/@root='1.2.250.1.213.1.1.3.102' and (cda:value/@code='MED-704' or cda:value/@code='MED-705' or cda:value/@code='MED-706' or cda:value/@code='MED-707'
                        or cda:value/@code='MED-708' or cda:value/@code='MED-709' or cda:value/@code='MED-710' or cda:value/@code='MED-711' or cda:value/@code='MED-712' or cda:value/@code='MED-713'
                        or cda:value/@code='MED-714')]) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pT_CISIS.xml'
                        else '../jeuxDeValeurs/JDV_TNM_pTNM_pT_CISIS.xml'
                        "/>
                <let name="jdv_TNM_pTNM_pN_CISIS" value="
                        if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='C3868']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pN_1_CISIS.xml' 
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='MED-715']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pN_1_CISIS.xml'
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='MED-718']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pN_1_CISIS.xml'
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation
                        [cda:templateId/@root='1.2.250.1.213.1.1.3.102' and (cda:value/@code='MED-704' or cda:value/@code='MED-705' or cda:value/@code='MED-706' or cda:value/@code='MED-707'
                        or cda:value/@code='MED-708' or cda:value/@code='MED-709' or cda:value/@code='MED-710' or cda:value/@code='MED-711' or cda:value/@code='MED-712' or cda:value/@code='MED-713'
                        or cda:value/@code='MED-714')]) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pN_CISIS.xml'
                        else '../jeuxDeValeurs/JDV_TNM_pTNM_pN_CISIS.xml'
                        "/> 
                <let name="jdv_TNM_pTNM_pM_CISIS" value="
                        if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='C3868']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pM_1_CISIS.xml' 
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='MED-715']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pM_2_CISIS.xml'
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.102' and cda:value/@code='MED-718']) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pM_1_CISIS.xml'
                        else if(cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:organizer/cda:component/cda:observation
                        [cda:templateId/@root='1.2.250.1.213.1.1.3.102' and (cda:value/@code='MED-704' or cda:value/@code='MED-705' or cda:value/@code='MED-706' or cda:value/@code='MED-707'
                        or cda:value/@code='MED-708' or cda:value/@code='MED-709' or cda:value/@code='MED-710' or cda:value/@code='MED-711' or cda:value/@code='MED-712' or cda:value/@code='MED-713'
                        or cda:value/@code='MED-714')]) 
                        then '../jeuxDeValeurs/JDV_TNM_pTNM_pM_CISIS.xml'
                        else '../jeuxDeValeurs/JDV_TNM_pTNM_pM_CISIS.xml'
                        "/>
                <rule context="cda:ClinicalDocument/cda:component/cda:structuredBody">
                        
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.6']"> 
                                [CANCER-CR-ACP-COLON-RECTUM_2021.01] Erreur de conformité : La section "Prélèvement" (1.3.6.1.4.1.19376.1.8.1.2.6) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.3']"> 
                                [CANCER-CR-ACP-COLON-RECTUM_2021.01] Erreur de conformité : La section "Examen macroscopique" (1.3.6.1.4.1.19376.1.8.1.2.3) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.4']"> 
                                [CANCER-CR-ACP-COLON-RECTUM_2021.01] Erreur de conformité : La section "Examen microscopique" (1.3.6.1.4.1.19376.1.8.1.2.4) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section[cda:templateId/@root='1.3.6.1.4.1.19376.1.3.10.3.1']/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.8.1.4.9' and cda:code/@code='MED-864']"> 
                                [CANCER-CR-ACP-COLON-RECTUM_2021.01] Erreur de conformité : La section "Constatations pathologiques complementaires Examen / Tumeur - Code lésion" (1.3.6.1.4.1.19376.1.8.1.2.5) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section[cda:templateId/@root='1.3.6.1.4.1.19376.1.3.10.3.1']/cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='1.3.6.1.4.1.19376.1.8.1.4.9' and cda:code/@code='31210-8']">
                                [CANCER-CR-ACP-COLON-RECTUM_2021.01] Erreur de conformité : La section "Constatations pathologiques complementaires Statut R (synthèse) - Statut R (synthèse)" (1.3.6.1.4.1.19376.1.8.1.2.5) doit être présente.
                        </assert>
                        <assert test="cda:component/cda:section/cda:templateId[@root='1.3.6.1.4.1.19376.1.8.1.2.5']"> 
                                [CANCER-CR-ACP-COLON-RECTUM_2021.01] Erreur de conformité : La section "Conclusion Diagnostic" (1.3.6.1.4.1.19376.1.8.1.2.5) doit être présente.
                        </assert>
                </rule>
        </pattern>
</schema>