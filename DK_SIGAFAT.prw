User Function SIGAFAT()       

Public _cVend     := SPACE(6) 

dbSelectArea("SA3") 
dbSetorder(7) 
If dbSeek(xFilial("SA3")+RETCODUSR()) .AND. !RETCODUSR()$GETMV("Dk_USRVPRV")
	
	_cVend     :=     SA3->A3_COD 

	DBSELECTAREA("SC5")
        SET FILTER TO Substr(SC5->C5_VEND1,1,6) == Substr(_cVend,1,6)
    DBGOTOP()           

	DBSELECTAREA("SF2")
        SET FILTER TO Substr(SF2->F2_VEND1,1,6) == Substr(_cVend,1,6)
    DBGOTOP()          

Endif

//DBCloseArea()
//Teste Johnny Fernandes
Return
