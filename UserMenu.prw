#Include "protheus.ch"

// --------------------------------------------------------------
//
// RELATORIO PARA EXIBIÇÃO DE USUARIOS E SEUS RESPECTIVOS MENUS
//
// MARCOS TEIXEIRA DE MELLO - 22 OUTUBRO 2015
//
// --------------------------------------------------------------


User Function UserMenu()
Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Usuários x Menus"
Local cPict			:= ""
Local titulo		:= "Usuários x Menus - "
Local nLin			:= 79

//						0		  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//						012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1		:= " CODIGO  LOGIN           NOME COMPLETO                      DEPARTAMENTO"
Local Cabec2		:= ""
Local imprime       := .T.
Local aOrd := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private CbTxt        := ""
Private tamanho     := "M"
Private nomeprog    := "USERMENU" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := ""
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      	:= "USERMENU" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SA1"

//pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := titulo + DTOC(date())

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


// ------------------
// MONTA O RELATÓRIO
// ------------------
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local aDados 		:= allUsers(.F.,.T.)
Local n,n2,n3		:= 0
Local nTot			:= 0
Local nTotG			:= 0

SetRegua(len(aDados))

for n:=1 to len(aDados)
	
	nTotG++
	
	//Somente ativos
	if !aDados[n][1][17]
		
		IncRegua()
		
		nTot++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página.
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,01 psay aDados[n][1][1]
		@nLin,08 psay aDados[n][1][2]
		@nLin,25 psay aDados[n][1][4]
		@nLin,60 psay aDados[n][1][12]
		
		nLin++
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,01 psay "MENUS:"
		
		// Exibe os menus do usuario, em 4 colunas por linha
		n3	:= 0
		for n2	:= 1 to len(aDados[n][3])
			if n3+n2 <= len(aDados[n][3]) .and. substr(aDados[n][3][n2],3,1)<>"X"
				@nLin,10+(n3*32) psay aDados[n][3][n2]
				n3++
				if n3 = 4
					n3:=0
					
					@nLin++
					If nLin > 55
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					endif
					
				endif
			endif
		next n2
		
		//ajusta a ultima linha
		if n3=0
			nLin--
		endif
		
		nLin++
		nLin++
		nLin++
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
	endif
next n

// Exibe o totalizador
nLin++
If nLin > 55
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

@nLin,0 psay "TOTAL DE USUÁRIOS ATIVOS: "+alltrim(str(nTot))+" de "+alltrim(str(nTotG))



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
