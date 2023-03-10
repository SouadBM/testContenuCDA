<?xml version="1.0" encoding="UTF-8"?>

<!--                  
    Entete_DLU-DLU.sch
    Teste la conformité de l'entete du volet DLU au CI-SIS
    
    Historique :
    07/02/2018 : Création
    22/02/2021 : Renomage schématron
-->


<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="Entete_DLU-DLU">
    
    <rule context='cda:ClinicalDocument'>
        <assert test="cda:templateId[@root='1.2.250.1.213.1.1.1.22']"> 
            [Entete_DLU-DLU] Le templateId "1.2.250.1.213.1.1.1.22" (Conformité au modèle DLU-DLU du CI-SIS) doit être présent.
        </assert>
        <assert test="cda:code[@code='74207-2' and @codeSystem='2.16.840.1.113883.6.1']"> 
            [Entete_DLU-DLU] L'élément code doit avoir @code ="74207-2" et @codeSystem = "2.16.840.1.113883.6.1"/>. 
        </assert>
        
        <assert test="cda:recordTarget/cda:patientRole/cda:patient/cda:birthTime">
            [Entete_DLU-DLU] La date de naissance du patient est obligatoirement présente
        </assert>
        
        <assert test="cda:participant[@typeCode='INF']">
            [Entete_DLU-DLU] Dans le contexte du DLU, le typeCode du participant est fixé à 'INF'
        </assert>

        <assert test="cda:participant/cda:functionCode[@code='PCP']">
            [Entete_DLU-DLU] Dans le contexte du DLU, le code du functionCode de l'informant est fixé à 'PCP'
        </assert>
        
        <assert test="cda:documentationOf/cda:serviceEvent/cda:code[@code='34117-2']">
            [Entete_DLU-DLU] L'attribut code de l'élément documentationOf/serviceEvent/code est fixé à '34117-2'
        </assert>
        
        <assert test="cda:documentationOf/cda:serviceEvent/cda:effectiveTime">
            [Entete_DLU-DLU] Dans le contexte du DLU, la date du début d'exécution de l'acte est obligatoire
        </assert>
        <report test="cda:documentationOf/cda:serviceEvent/cda:effectiveTime[@nullFlavor] or cda:documentationOf/cda:serviceEvent/cda:effectiveTime/cda:low[@nullFlavor]">
            [Entete_DLU-DLU] Dans le contexte du DLU, l'utilisation du nullFlavor pour la date du début d'exécution de l'acte est interdite
        </report>
        
    </rule>
</pattern>