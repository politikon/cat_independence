clear all
set more off
use "ceo.dta"

// Pesos lengua
*Lengua inicial
scalar linc_cat=31
scalar linc_esp=55.1
scalar linc_dos=2.4
scalar linc_otr=10.6
*Lengua habitual
scalar lhab_cat=36.3
scalar lhab_esp=50.7
scalar lhab_dos=6.8
scalar lhab_otr=5.9
*Lengua propia
scalar lpro_cat=36.4
scalar lpro_esp=47.6
scalar lpro_dos=7
scalar lpro_otr=8.5 
 

// Recoding
gen indepe=.
replace indepe=1 if P30==4
replace indepe=0 if P30==1 | P30==2 | P30==3
label define indepe 0 "No" 1 "Si"
label values indepe indepe

/* Old DV

gen inde=P31
replace inde=. if inde==99
replace inde=. if inde==98
replace inde=. if inde==97
revrs inde
drop inde
rename revinde inde
replace inde=inde-1
label define inde 0 "No" 1 "Si"
label values inde inde

* Inde per BOP_NUM de 2014
gen inde2=P31A_P31B
replace inde2=2 if inde2==6
replace inde2=. if inde2>2
revrs inde2
drop inde2
rename revinde inde2
replace inde2=inde2-1
label values inde2 inde

* Merging Inde's
replace inde=0 if inde2==0
replace inde=1 if inde2==1
*/

gen iden=C700
replace iden=. if iden==99 | iden==98
replace iden=iden-1
replace iden=1 if iden==0
label define iden 1 "Espanyol" 2 "Els dos" 3 "MŽs Catalˆ" 4 "NomŽs Catalˆ"
label values iden iden

gen nvida=P32
replace nvida=. if nvida==99 | nvida==98

gen sent=P45
replace sent=. if sent==98
replace sent=. if sent==99
label values sent P45

gen inc=C900
replace inc=. if inc==98
replace inc=. if inc==99
label values inc C900


* Ingressos per quintils/deciles

* NEED TO INSTALL THIS: ssc install egenmore
egen inc_5 = xtile(inc), by(BOP_NUM) nq(5)
egen inc_10 = xtile(inc), by(BOP_NUM) nq(10)

gen lang=C705
replace lang=. if lang==98
replace lang=. if lang==80
replace lang=. if lang==4
label values lang C705
replace lang=4 if lang==2
replace lang=2 if lang==3
replace lang=3 if lang==4
label define lang 1 "Cat" 2 "Igual" 3 "Cast"
label values lang lang

gen age=GR_EDAT
label values age GR_EDAT

gen educ=.
replace educ=1 if C500==1 | C500==2 | C500==3
replace educ=2 if C500==4 | C500==5 | C500==6 | C500==7
replace educ=3 if C500==8 | C500==9 | C500==10 | C500==11
label define educ 1 "Primaria" 2 "Secundaria" 3 "Universitat"
label values educ educ

gen inpol=P14
replace inpol=. if inpol==99
replace inpol=. if inpol==98
label values  inpol P14

gen neix=C100
replace neix=. if neix==99
replace neix=neix-1
replace neix=1 if neix==2 | neix==3
label define neix 0 "Cat" 1 "Fora"
label values neix neix

gen neixpa=C110
replace neixpa=. if neixpa==99
replace neixpa=. if neixpa==98
replace neixpa=. if neixpa==97
replace neixpa=neixpa-1
replace neixpa=1 if neixpa==2 | neixpa==3
label values neixpa neix

gen neixma=C120
replace neixma=. if neixma==99
replace neixma=. if neixma==98
replace neixma=. if neixma==97
replace neixma=neixma-1
replace neixma=1 if neixma==2 | neixma==3
label values neixma neix

gen neixpares=.
replace neixpares = 0 if neixpa==0 & neixma==0
replace neixpares = 1 if neixpa==1 & neixma==0
replace neixpares = 1 if neixpa==0 & neixma==1
replace neixpares = 2 if neixpa==1 & neixma==1
label define neixpares 0 "Dos Cat" 1 "Un i un" 2 "Dos Fora"
label values neixpares neixpares

gen ideo=P25
replace ideo=. if ideo==99
replace ideo=. if ideo==98

gen atur=P1_200_R
label define atur 0 "No" 1 "Si"
label values atur atur

*P24 simpat’a partits
gen simp=P24
replace simp=. if simp==98 | simp==99
replace simp=80 if simp==11 | simp==7 | simp==9 | simp==8
replace simp=12 if simp==13
label values simp P24

*P20AConfiana pol’tics catalans
gen confia=P20A
replace confia=. if confia==99 | confia==98

*P16A_REC --> TV3
gen tv3=0
replace tv3=1 if P16A_REC==3 | P16A_REC==4 | P16A_REC==11 | P16A_REC==12 | P16A_REC==81 | P16A_REC==82

*C800 -> Clase Social
gen clase=C800
replace clase=. if clase==98 | clase==99
label values clase clase

* Instalar "revrs" (sirve para revertir la variable).
revrs nvida
revrs lang
revrs neix





//Modelo
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
*outreg2 using regs.doc, replace label word ctitle ("M1")

//Gr‡ficas

* Lengua
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
margins revlang, atmeans
marginsplot

* Nacimiento
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
margins revneix, atmeans
marginsplot

* Ingresos
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
margins, at(inc_10==(1(1)10)) atmeans
marginsplot

* Educaci—n
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
margins educ, atmeans
marginsplot

* Ideolog’a
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
margins, at(ideo==(0(1)10)) atmeans
marginsplot

* Tama–o municipio
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat
margins, at(habitat==(1(1)6)) atmeans
marginsplot

* Interacci—n Ingresos x Lengua
logit indepe ib2.revlang i.revneix inc_10 i.sexe age i.educ ideo habitat i.revlang#c.inc_10
margins, at(inc_10==(1(1)10)) by(revlang) atmeans 
marginsplot





/* VARIABES:
Indepe -> Dummy independencia (basada en la P30)
inc -> Ingressos
lang -> Primera llengua parlada
age -> Edat per trams
educ -> Nivell formaci—
sexe
neix -> LLoc neixement enquestat
neixpa -> Lloc nexement del pare
neixpares -> Combinat neixament pares
ideo -> Ideologia
habitat -> Tamany municipi
atur -> Atur com a principal problema
inpol -> InterŽs per la pol’tica (omesa)
confia -> Confiana en pol’tics catalans
tv3 -> Veu medis de tele catalans
clas -> Autoubicaci— clase social
*/



















/* USELESS STUFF:
/*

/* Model Original
*logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
logit indepe ib2.iden ib2.revlang i.revneix i.sexe age i.educ ideo habitat
outreg2 using regs.doc, replace label word ctitle ("Identitary")

logit indepe ib2.iden ib2.revlang i.revneix ib2.revnvida inc_10 clase i.sexe age i.educ ideo habitat
outreg2 using regs.doc, replace label word ctitle ("M1")


logit indepe ib2.iden ib2.revnvida ib95.simp confia ib2.revlang i.revneix tv3 inc_10 i.sexe age i.educ ideo habitat i.provi

logit indepe nvida i.lang i.neixpares inc_10 age educ sexe ideo habitat
outreg2 using regs.doc, append label word ctitle ("M2")
logit indepe i.lang i.neixpares inc_10 age educ sexe ideo habitat
outreg2 using regs.doc, append label word ctitle ("M3")
*/





//Amb ingressos i educaci— com a categoriques
logit indepe i.inc_10 i.lang i.age i.educ i.sexe i.neix i.neixpares ideo i.habitat i.atur

*Per onada
logit indepe inc i.lang age educ sexe i.neix i.neixpares if BOP_NUM==32
logit indepe inc i.lang age educ sexe i.neix i.neixpares if BOP_NUM==33
logit indepe inc i.lang age educ sexe i.neix i.neixpares if BOP_NUM==34
logit indepe inc i.lang age educ sexe i.neix i.neixpares if BOP_NUM==35

*Linear prediction per ona sense conrols:
twoway (lfitci indepe inc_10), by(BOP_NUM)
*/

// Ingressos
logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(inc_10=(1(1)10))
marginsplot

// EDUC
logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(educ=(1(1)11))
marginsplot

// Ideolog’a
logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(ideo=(1(1)10))
marginsplot

// Tama–o
logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(habitat=(1(1)6))
marginsplot

// Lengua
logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(lang=(1(1)3))
marginsplot

// Neixament Pares
logit indepe inc_10 i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(neixpares=(0(1)2))
marginsplot



// INTERACCIONES //

// ---> INGRESOS + LENGUA

// Interacci—n Ingressos + Lengua
logit indepe inc i.lang c.inc#i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(inc=(1(1)15)) by(lang) vsquish post
marginsplot, level(90)

// Interacci—n Ingressos (quintiles) + Lengua
logit indepe inc_5 i.lang c.inc_5#i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(inc_5=(1(1)5)) by(lang)
marginsplot, level(90)

// Interacci—n Ingressos (deciles) + Lengua
logit indepe inc_10 i.lang c.inc_10#i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(inc_10=(1(1)10)) by(lang)
marginsplot, level(90)

* ----> INGRESOS + LENGUA [CATEGORICA]

// Interacci—n Ingressos (quintiles) + Lengua [CATEGORICA] --> Gr‡fico que tenemos ahora
logit indepe i.inc_5 i.lang i.inc_5#i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(inc_5=(1(1)5)) by(lang)
marginsplot, level(90)

// Interacci—n Ingressos (deciles) + Lengua [CATEGORICA] --> EL QUE FA BALCELLS...
logit indepe i.inc_10 i.lang i.inc_10#i.lang age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(inc_10=(1(1)10)) by(lang)
marginsplot, level(90)


// ---> INGRESOS + IDEOLOGIA

//Interacci— ingressos + ideologia
logit indepe inc_5 i.ideo c.inc_5#i.ideo i.lang age educ sexe i.neix i.neixpares habitat i.atur
margins, at(ideo=(1(1)10)) by (inc_5)
marginsplot, level(90)


// ---> IDEOLOGIA + LLENGUA

//Interacci— ideologia + llengua
logit indepe inc_10 i.ideo i.ideo#i.lang i.lang age educ sexe i.neix i.neixpares habitat i.atur
margins, at(ideo=(1(1)10)) by (lang)
marginsplot, level(90)


logit indepe inc_10 i.lang c.inc_10#neixpares age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, dydx(neixpares) at(inc_10=(1(1)10))
marginsplot, level(90)


logit indepe inc_10 i.lang c.educ#neix age educ sexe i.neix i.neixpares ideo habitat i.atur
margins, at(educ=(1(1)11)) by(neix)
marginsplot, level(90)


	
// Modelo Per Sentiment Independentista (Segunda Entrada?)
set more off	
mlogit sent inc inc lang age educ
margins, at(inc=(1(1)15)) predict(outcome(1)) saving(1, replace)

mlogit sent inc inc lang age educ
margins, at(inc=(1(1)15)) predict(outcome(2)) saving(2, replace)

mlogit sent inc inc lang age educ
margins, at(inc=(1(1)15)) predict(outcome(3)) saving(3, replace)

combomarginsplot 1 2 3, ///
    labels("Indepe" "Nou" "No") ///
	legend(position(6) row(1)) ///
	xsize(5)
*gr save renta.gph, replace
*gr export renta.png, replace




