#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "ap5mail.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³NEW Programa  ³ WFCOMAUTO2³Autor ³ ATENDITI MYI  ³ Data ³ 15/07/2019³   ±±
±±³OLD Programa  ³ WFCOMAUTO2³Autor ³ TECNORAV         ³ Data ³ 2017 ³	   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório das compras detalhada por Grupo                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACOM                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION WFCOMAUTO2() 

	Local 	_cxUserWF		:= ""
	Local 	_cxPassWF		:= ""
	
	Private oProcess
	Private oHtml
	Private nSaldoLote		:= 0
	Private cData 			:= ""
	Private dData			:= CTOD("")
	Private nDiaDaSemana 	:= 0
	Private cDiaDaSemana 	:= 0

	Private nQTD_COM 		:= 0	// COMPRAS "A" QTD
	Private nTOT_COM 		:= 0	// COMPRAS "A" VALOR
	
	Private nQTD_PC 		:= 0	// CARTEIRA "B" QTD
	Private nTOT_PC 		:= 0	// CARTEIRA "B" VALOR  
	
	Private nQTD_DEV 		:= 0	// CARTEIRA "C" QTD
	Private nTOT_DEV 		:= 0	// CARTEIRA "C" VALOR 

	Private nQTD_COMO 		:= 0	// COMPRAS "A" QTD OUTROS
	Private nTOT_COMO 		:= 0	// COMPRAS "A" VALOR OUTROS
	
	Private nQTD_PCO 		:= 0	// CARTEIRA "B" QTD OUTROS
	Private nTOT_PCO 		:= 0	// CARTEIRA "B" VALOR OUTROS  
	
	Private nQTD_DEVO 		:= 0	// CARTEIRA "C" QTD OUTROS
	Private nTOT_DEVO 		:= 0	// CARTEIRA "C" VALOR OUTROS 

	
	Private aCorLinha		:= {}
	
	Private X				:= 1 
	Private Y				:= 1
	Private cMailAdmWF		:= " "
	Private cMailID 		:= ""
	
	Private	cGRPMP			:= ""

	//Default lJob			:= .T.
	CONOUT("INICIANDO WF COMPRAS")
	
	cData 				:= SUBSTR(DTOS(DATE()),1,6) 	// Resultado: 09/01/01
	nDiaDaSemana 		:= DOW (DATE()) 				// Resultado: 3
	cDiaDaSemana 		:= CDOW(DATE()) 				// Resultado: Tuesday

	/*If	lJob
	
		//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '0101' USER 'admin' PASSWORD 'dakhia2017' TABLES 'SB1,SD2,SF4,SC6,SC5' MODULO 'COM'
		RPCSetEnv("01","01")

		cData 				:= SUBSTR(DTOS(DATE()),1,6) 	// Resultado: 09/01/01
		nDiaDaSemana 		:= DOW (DATE()) 				// Resultado: 3
		cDiaDaSemana 		:= CDOW(DATE()) 				// Resultado: Tuesday
		dData				:= dDatabase

	Else

		Pergunte("WFCOM01", .T.)
	
		cData 				:= SUBSTR(DTOS(mv_par01),1,6) 	// Resultado: 09/01/01
		nDiaDaSemana 		:= DOW (mv_par01)				// Resultado: 3
		cDiaDaSemana 		:= CDOW(mv_par01) 				// Resultado: Tuesday
		dData				:= mv_par01

		//cData 				:= SUBSTR(DTOS(DATE()),1,6) 	// Resultado: 09/01/01  ***** VOLTAR ESSA DATA !!!!! ***###### 
		cData 				:= SUBSTR(DTOS(dDatabase),1,6) 	// Resultado: 09/01/01
		nDiaDaSemana 		:= DOW (DATE()) 				// Resultado: 3
		cDiaDaSemana 		:= CDOW(DATE()) 				// Resultado: Tuesday
		dData				:= dDatabase
	
	EndIf*/

    RPCSetEnv("01","01")	
	CONOUT("INICIANDO WF COMPRAS 2")
	oProcess := TWFProcess():New( "COMPRAS","COMPRAS LANCAMENTO")						//Cria objeto
	oProcess:NewTask( "COMPRAS","\WORKFLOW\Modelos\COM\index_WFCOM2.html" )			//Cria tarefa para o processo	
	
	oHtml := oProcess:oHtml
	
	oHtml:ValByName( "DATA",DtoC(dDatabase))	// DtoC(dDatabase))
	oHtml:ValByName( "MES" ,SUBSTR(cData,5,2)+"/"+SUBSTR(cData,1,4))
	
	aCorLinha2 	:= {"#FFFFFF","#FFD966"}        //LARANJA - OUTROS GRUPOS


	aCorLinha 	:= {"#FFFFFF","#BDD7EE"}  //AZUL - MP + ADITIVOS
	nQTD_COM	:= 0	// COMPRAS  "A" QTD
	nTOT_COM	:= 0	// COMPRAS  "A" VALOR
	nQTD_PC		:= 0	// CARTEIRA "B" QTD
	nTOT_PC		:= 0	// CARTEIRA "B" VALOR 
	nQTD_DEV	:= 0	// CARTEIRA "C" QTD
	nTOT_DEV	:= 0	// CARTEIRA "C" VALOR

	PRODUTO()
	
	CONOUT("INICIANDO WF COMPRAS 3")
	cMailAdmWF := SuperGetMv("MV_XPCMAIL",.F., "financeiro@dakhia.ind.br")
			
	oHtml:ValByName( "DIA1" , cDiaDaSemana)
	
	cMailID				:= oProcess:Start("\workflow\emp"+cEmpAnt+"\wfcom\")   //Faz a gravacao do e-mail no cPath
		 
	oProcess:cTo		:= SuperGetMV("DK_COMMAIL",.F.,"financeiro@dakhia.ind.br;olivia@dakhia.ind.br")	//"financeiro@dakhia.ind.br;olivia@dakhia.ind.br"	// Destinatario WORKFLOW
	oProcess:cBCC		:= ""												// Copia Oculta WORKFLOW
	oProcess:cBCC		:= cMailAdmWF										// Copia Oculta WORKFLOW
	oProcess:cSubject	:= "DAKHIA WORKFLOW COMPRAS" 						// Assunto Mensagem
	oProcess:Start()														// Gera os arquivos de controle deste processo e envia a mensagem
	
//	RESET ENVIRONMENT	

RETURN

STATIC FUNCTION PRODUTO()
	cGRPMP	:= SuperGetMv("DK_XGRPMP",.F., '0001;0002;0003;0004;0005;0006;0007;0008;0009;0016;0017;0018;0019;0020;0021;0024;0027;0032;0034;0041;0042;0043;0044')
	
	_cTexto	:= ""                          
	_cTexto2:= ""                         

	_cTexto	+= "SELECT B1_GRUPO, "
	_cTexto	+= "SUM(QTD_COM) QTD_COM, "
	_cTexto	+= "SUM(TOT_COM) TOT_COM, "
	_cTexto	+= "SUM(QTD_PC ) QTD_PC , "
	_cTexto	+= "SUM(TOT_PC ) TOT_PC ,"
	_cTexto	+= "SUM(QTD_DEV) QTD_DEV, "
	_cTexto	+= "SUM(TOT_DEV) TOT_DEV "
	_cTexto	+= "  FROM ( "
	_cTexto	+= "SELECT C7_PRODUTO PRODUTO,B1_DESC DESC_PROD, B1_GRUPO, "
	_cTexto	+= "SUM(0) QTD_COM, "
	_cTexto	+= "SUM(0) TOT_COM, "
	_cTexto	+= "SUM((C7_QUANT-C7_QUJE)) QTD_PC, "
	_cTexto	+= "SUM(CASE  "
	_cTexto	+= "    WHEN SB1.B1_IPI>0 THEN ((SC7.C7_TOTAL/SC7.C7_QUANT)*(SC7.C7_QUANT-SC7.C7_QUJE)) * ((SB1.B1_IPI/100)+1)  "
	_cTexto	+= "    ELSE ((SC7.C7_TOTAL/SC7.C7_QUANT)*(SC7.C7_QUANT-SC7.C7_QUJE))  "
	_cTexto	+= "     END) TOT_PC, 	 "
	_cTexto	+= "SUM(0) QTD_DEV, "
	_cTexto	+= "SUM(0) TOT_DEV "
	_cTexto	+= "  FROM SC7010 SC7  "
	_cTexto	+= " INNER JOIN SA2010 SA2 ON (SA2.A2_COD    = SC7.C7_FORNECE AND SA2.A2_LOJA    = SC7.C7_LOJA AND SA2.D_E_L_E_T_=' ') "
	_cTexto	+= " INNER JOIN SB1010 SB1 ON (SB1.B1_COD    = SC7.C7_PRODUTO AND SB1.D_E_L_E_T_ = ' ') "
	_cTexto	+= " INNER JOIN SE4010 SE4 ON (SE4.E4_CODIGO = SC7.C7_COND    AND SE4.D_E_L_E_T_ = ' ') "
	_cTexto	+= " WHERE SC7.D_E_L_E_T_            = ' '  "
	_cTexto	+= "   AND SC7.C7_ENCER              = ' '  "   
	_cTexto	+= "   AND SC7.C7_CONAPRO            = 'L'  "     
	_cTexto	+= "   AND SC7.C7_RESIDUO           != 'S'  "
	_cTexto	+= "   AND SC7.C7_FILIAL             = '01' " 
	_cTexto	+= "   AND SUBSTR(SC7.C7_DATPRF,1,6)<= '" + ALLTRIM(cData) + "' "
	_cTexto	+= " GROUP BY C7_PRODUTO,B1_DESC,B1_GRUPO " 


	_cTexto	+= " UNION ALL "

	_cTexto	+= "SELECT D1_COD,B1_DESC,B1_GRUPO, "
	_cTexto	+= "SUM(SD1.D1_QUANT) QTD_COM, "
//	_cTexto	+= "SUM(SD1.D1_TOTAL+SD1.D1_VALIPI) TOT_COM, "
	
	_cTexto	+= "SUM(CASE  "
	_cTexto	+= "    WHEN SD1.D1_TES IN ('010','075') THEN (SD1.D1_TOTAL) "
	_cTexto	+= "    ELSE (  (SD1.D1_TOTAL+SD1.D1_VALIPI)) "
	_cTexto	+= "     END) TOT_COM, "
	
	_cTexto	+= "SUM(0) QTD_PC, "
	_cTexto	+= "SUM(0) TOT_PC,  "
	_cTexto	+= "SUM(SD1.D1_QTDEDEV) QTD_DEV, "
	_cTexto	+= "SUM(SD1.D1_VALDEV) TOT_DEV "
	_cTexto	+= "  FROM SD1010 SD1  "
	_cTexto	+= " INNER JOIN SF1010 SF1 ON (SF1.F1_DOC    = SD1.D1_DOC     AND SF1.F1_SERIE   = SD1.D1_SERIE AND SF1.F1_FORNECE   = SD1.D1_FORNECE AND SF1.F1_LOJA   = SD1.D1_LOJA AND SF1.D_E_L_E_T_=' ') "
	_cTexto	+= " INNER JOIN SA2010 SA2 ON (SA2.A2_COD    = SF1.F1_FORNECE AND SA2.A2_LOJA    = SF1.F1_LOJA  AND SA2.D_E_L_E_T_=' ')  "
	_cTexto	+= " INNER JOIN SB1010 SB1 ON (SB1.B1_COD    = SD1.D1_COD     AND SB1.D_E_L_E_T_ = ' ')  "
	_cTexto	+= " INNER JOIN SE4010 SE4 ON (SE4.E4_CODIGO = SF1.F1_COND    AND SE4.D_E_L_E_T_ = ' ')  "
	_cTexto	+= " WHERE SD1.D_E_L_E_T_ = ' '  "
	_cTexto	+= "   AND EXISTS  (SELECT * FROM SF4010 SF4 WHERE SF4.D_E_L_E_T_=' ' AND  SF4.F4_DUPLIC = 'S' AND  SF4.F4_CODIGO = SD1.D1_TES)  "
	_cTexto	+= "   AND SUBSTR(SD1.D1_DTDIGIT,1,6) = '" + ALLTRIM(cData) + "' "
	_cTexto	+= "   AND SD1.D1_TIPO!='D'  "
	_cTexto	+= "GROUP BY D1_COD,B1_DESC,B1_GRUPO "
	_cTexto	+= ") RESULT  "
	_cTexto	+= "GROUP BY B1_GRUPO "
	_cTexto	+= "ORDER BY B1_GRUPO "

//	MEMOWRITE("C:\RELATO\WFCOM_Produto" + cArquivo + ".TXT",_cTexto)
	

	DbUseArea( .T., "TOPCONN", TCGENQRY(,,_cTexto),"TB1", .F., .T.)	 
     		
	WHILE TB1->(!Eof())
	
		nQTD_COM	+= TB1->QTD_COM		// COMPRAS "A" QTD
		nTOT_COM	+= TB1->TOT_COM		// COMPRAS "A" VALOR
		
		nQTD_PC		+= TB1->QTD_PC		// CARTEIRA "B" QTD			
		nTOT_PC		+= TB1->TOT_PC		// CARTEIRA "B" VALOR	 
		
		nQTD_DEV	+= TB1->QTD_DEV		// CARTEIRA "C" QTD			
		nTOT_DEV	+= TB1->TOT_DEV		// CARTEIRA "C" VALOR	
		

		
		//Tratativa das cores
		IF X > 2
			X := 1		
		ENDIF			 
		
		//Tratativa das cores
		IF Y > 2
			Y := 1		
		ENDIF			
		
	If ALLTRIM(TB1->B1_GRUPO)$cGRPMP
		AAdd( (oHtml:ValByName( "it.corlinha"	))	, aCorLinha[X])		
		AAdd( (oHtml:ValByName( "it.PROD"		))	, "&nbsp;"+ALLTRIM(TB1->B1_GRUPO+" - "+ALLTRIM(GetAdvFval("SBM","BM_DESC",xFilial("SBM")+TB1->B1_GRUPO,1))))
		
		AAdd( (oHtml:ValByName( "it.ABSFQTD" 	))	, ALLTRIM(TRANSFORM(TB1->QTD_COM				,'@E 9,999,999,999,999'))	+"&nbsp;")											// FATURAMENTO "A" QTD 
		AAdd( (oHtml:ValByName( "it.ABSFVALOR" 	))	, ALLTRIM(TRANSFORM(TB1->TOT_COM				,'@E 9,999,999,999,999.99'))+"&nbsp;")											// FATURAMENTO "A" VALOR
		
		AAdd( (oHtml:ValByName( "it.ABSCQTD" 	))	, ALLTRIM(TRANSFORM(TB1->QTD_PC					,'@E 9,999,999,999,999'))	+"&nbsp;")											// CARTEIRA "B" QTD
		AAdd( (oHtml:ValByName( "it.ABSCVALOR" 	))	, ALLTRIM(TRANSFORM(TB1->TOT_PC					,'@E 9,999,999,999,999.99'))+"&nbsp;")											// CARTEIRA "B" VALOR  

		AAdd( (oHtml:ValByName( "it.ABSDQTD" 	))	, ALLTRIM(TRANSFORM(TB1->QTD_DEV					,'@E 9,999,999,999,999'))	+"&nbsp;")											// CARTEIRA "C" QTD
		AAdd( (oHtml:ValByName( "it.ABSDVALOR" 	))	, ALLTRIM(TRANSFORM(TB1->TOT_DEV					,'@E 9,999,999,999,999.99'))+"&nbsp;")											// CARTEIRA "C" VAL
		
		AAdd( (oHtml:ValByName( "it.ABSTQTDAB"	))	, ALLTRIM(TRANSFORM(TB1->QTD_COM + TB1->QTD_PC - TB1->QTD_DEV	,'@E 9,999,999,999,999'))	+"&nbsp;")							// TOTAL (A + B ) QTD
		AAdd( (oHtml:ValByName( "it.ABSTVALORAB"))	, ALLTRIM(TRANSFORM(TB1->TOT_COM + TB1->TOT_PC - TB1->TOT_DEV	,'@E 9,999,999,999,999.99'))+"&nbsp;")							// TOTAL (A + B ) VALOR 
	
		X++		//Tratativa das cores

	ELSE
		AAdd( (oHtml:ValByName( "conc.corlinha"	))	, aCorLinha2[Y])		
		AAdd( (oHtml:ValByName( "conc.PROD"		))	, "&nbsp;"+ALLTRIM(TB1->B1_GRUPO+" - "+ALLTRIM(GetAdvFval("SBM","BM_DESC",xFilial("SBM")+TB1->B1_GRUPO,1))))
		
		AAdd( (oHtml:ValByName( "conc.ABSFQTD" 	))	, ALLTRIM(TRANSFORM(TB1->QTD_COM				,'@E 9,999,999,999,999'))	+"&nbsp;")											// FATURAMENTO "A" QTD 
		AAdd( (oHtml:ValByName( "conc.ABSFVALOR" 	))	, ALLTRIM(TRANSFORM(TB1->TOT_COM				,'@E 9,999,999,999,999.99'))+"&nbsp;")											// FATURAMENTO "A" VALOR
		
		AAdd( (oHtml:ValByName( "conc.ABSCQTD" 	))	, ALLTRIM(TRANSFORM(TB1->QTD_PC					,'@E 9,999,999,999,999'))	+"&nbsp;")											// CARTEIRA "B" QTD
		AAdd( (oHtml:ValByName( "conc.ABSCVALOR" 	))	, ALLTRIM(TRANSFORM(TB1->TOT_PC					,'@E 9,999,999,999,999.99'))+"&nbsp;")											// CARTEIRA "B" VALOR  

		AAdd( (oHtml:ValByName( "conc.ABSDQTD" 	))	, ALLTRIM(TRANSFORM(TB1->QTD_DEV					,'@E 9,999,999,999,999'))	+"&nbsp;")											// CARTEIRA "C" QTD
		AAdd( (oHtml:ValByName( "conc.ABSDVALOR" 	))	, ALLTRIM(TRANSFORM(TB1->TOT_DEV					,'@E 9,999,999,999,999.99'))+"&nbsp;")											// CARTEIRA "C" VAL
		
		AAdd( (oHtml:ValByName( "conc.ABSTQTDAB"	))	, ALLTRIM(TRANSFORM(TB1->QTD_COM + TB1->QTD_PC - TB1->QTD_DEV	,'@E 9,999,999,999,999'))	+"&nbsp;")							// TOTAL (A + B ) QTD
		AAdd( (oHtml:ValByName( "conc.ABSTVALORAB"))	, ALLTRIM(TRANSFORM(TB1->TOT_COM + TB1->TOT_PC - TB1->TOT_DEV	,'@E 9,999,999,999,999.99'))+"&nbsp;")							// TOTAL (A + B ) VALOR 
	    
		nQTD_COMO 		+= TB1->QTD_COM		// COMPRAS "A" QTD OUTROS
		nTOT_COMO 		+= TB1->TOT_COM 	// COMPRAS "A" VALOR OUTROS
		nQTD_PCO 		+= TB1->QTD_PC		// CARTEIRA "B" QTD OUTROS
		nTOT_PCO 		+= TB1->TOT_PC		// CARTEIRA "B" VALOR OUTROS  
		nQTD_DEVO 		+= TB1->QTD_DEV		// CARTEIRA "C" QTD OUTROS
		nTOT_DEVO 		+= TB1->TOT_DEV 	// CARTEIRA "C" VALOR OUTROS 
	
		Y++		//Tratativa das cores
	ENDIF
		
	//	X++		//Tratativa das cores
		
		TB1->(dbSkip())
		
  ENDDO
  
 TB1->(dbCloseArea())
 
 		//TOTAL GERAL (INCLUIR MAIS UMA LINHA)
        
		X++
		Y++
		
		IF X >= 2
			X := 1		
		ELSE
			X := 2
		ENDIF			
 		
 		AAdd( (oHtml:ValByName( "it.corlinha" 		))	, aCorLinha[X]) //Tratativa das cores 		
 		
	    AAdd( (oHtml:ValByName( "it.PROD"			))	, "<font size='3'><b>&nbsp;TOTAL</b></font>")
 		
 		AAdd( (oHtml:ValByName( "it.ABSFQTD" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nQTD_COM - nQTD_COMO			,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// FATURAMENTO "A" QTD
		AAdd( (oHtml:ValByName( "it.ABSFVALOR" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nTOT_COM	- nTOT_COMO			,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// FATURAMENTO "A" VALOR

		AAdd( (oHtml:ValByName( "it.ABSCQTD" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nQTD_PC - nQTD_PCO			,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// CARTEIRA "B" QTD
		AAdd( (oHtml:ValByName( "it.ABSCVALOR" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nTOT_PC - nTOT_PCO			,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// CARTEIRA "B" VALOR  
		
		AAdd( (oHtml:ValByName( "it.ABSDQTD" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nQTD_DEV - nQTD_DEVO			,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// CARTEIRA "C" QTD
		AAdd( (oHtml:ValByName( "it.ABSDVALOR" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nTOT_DEV - nTOT_DEVO			,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// CARTEIRA "C" VALOR 
		
		AAdd( (oHtml:ValByName( "it.ABSTQTDAB"		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM((nQTD_COM + nQTD_PC - nQTD_DEV - (nQTD_COMO + nQTD_PCO - nQTD_DEVO))	,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// TOTAL (A + B ) QTD															
		AAdd( (oHtml:ValByName( "it.ABSTVALORAB" 	))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM((nTOT_COM + nTOT_PC - nTOT_DEV - (nTOT_COMO + nTOT_PCO - nTOT_DEVO))	,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// TOTAL (A + B ) VALOR		


		//TOTAL GERAL (INCLUIR MAIS UMA LINHA) OUTROS
		
		IF 	Y >= 2
			Y := 1		
		ELSE
			Y := 2
		ENDIF			
		
		AAdd( (oHtml:ValByName( "conc.corlinha" 	))	, aCorLinha[Y]) //Tratativa das cores 		
		AAdd( (oHtml:ValByName( "conc.PROD"			))	, "<font size='3'><b>&nbsp;TOTAL</b></font>")		
		AAdd( (oHtml:ValByName( "conc.ABSFQTD" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nQTD_COMO			,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// FATURAMENTO "A" QTD
		AAdd( (oHtml:ValByName( "conc.ABSFVALOR" 	))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nTOT_COMO			,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// FATURAMENTO "A" VALOR
		
		AAdd( (oHtml:ValByName( "conc.ABSCQTD" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nQTD_PCO				,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// CARTEIRA "B" QTD
		AAdd( (oHtml:ValByName( "conc.ABSCVALOR" 	))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nTOT_PCO				,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// CARTEIRA "B" VALOR 
		
		AAdd( (oHtml:ValByName( "conc.ABSDQTD" 		))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nQTD_DEVO			,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// CARTEIRA "C" QTD
		AAdd( (oHtml:ValByName( "conc.ABSDVALOR" 	))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM(nTOT_DEVO			,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// CARTEIRA "C" VAL
		
		AAdd( (oHtml:ValByName( "conc.ABSTQTDAB"	))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM((nQTD_COMO + nQTD_PCO - nQTD_DEVO)	,'@E 9,999,999,999,999'))	+ "&nbsp;</b></font>")// TOTAL (A + B ) QTD															
		AAdd( (oHtml:ValByName( "conc.ABSTVALORAB" 	))	, "<font size='3'><b>" + ALLTRIM(TRANSFORM((nTOT_COMO + nTOT_PCO - nTOT_DEVO)	,'@E 9,999,999,999,999.99'))+ "&nbsp;</b></font>")// TOTAL (A + B ) VALOR		


RETURN

// Data	: 09/11/2017
// Autor: Fábio Jadao Caires	 
// Chamada manual do WF de Compras via menu

User Function WFCOMMAN()

//Chama a funcao do WF de Compras passando o parametro .F. - Se é Job (.T.) ou não (.F.)
U_WFCOMAUTO(.F.)


Return
