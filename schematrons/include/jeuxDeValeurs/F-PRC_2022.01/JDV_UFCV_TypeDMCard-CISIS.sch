<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    JDV_UFCV_TypeDMCard-CISIS.sch :
    Contenu :
    Contrôle du code du DM (nullFlavor interdit)
  
    Historique :
        15/11/2022 : Création
-->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="JDV_UFCV_TypeDMCard-CISIS" is-a="dansJeuDeValeurs">
    <p>Conformité CI-SIS du type de valve</p>
    <param name="path_jdv" value="$jdv_UFCV_TypeDMCard"/>
    <param name="vue_elt" value="ClinicalDocument/component/structuredBody/component/section/entry/supply/entryRelationship/observation/value"/>
    <param name="xpath_elt" value="cda:observation[cda:templateId/@root='1.2.250.1.213.1.1.3.1' and (cda:code/@code='L0004' or cda:code/@code='L0006')]/cda:value"/>
    <param name="nullFlavor" value="0"/>
</pattern>   