clear
use RawDataset.dta

gen ind=substr(sic_code,1,1)
gen Brown=0
replace Brown=1 if (ind=="B" | sic_code=="C20" | sic_code=="C21" | sic_code=="C22" | sic_code=="C25" | sic_code=="C26" | (sic_code!="D46" & ind=="D") | ind=="E")
gen Post=(Year>=2016)
gen Treated=Brown*Post
tab Year

sum2docx LeverageRatio FirmSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder if Brown==0 & Post==0 using Tab1.docx,replace stats(N mean sd min median max)
sum2docx LeverageRatio FirmSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder if Brown==1 & Post==0 using Tab1.docx,append stats(N mean sd min median max)
sum2docx LeverageRatio FirmSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder if Brown==0 & Post==1 using Tab1.docx,append stats(N mean sd min median max)
sum2docx LeverageRatio FirmSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder if Brown==1 & Post==1 using Tab1.docx,append stats(N mean sd min median max)

corr2docx LeverageRatio Brown Post Treated FirmSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder using Tab2.docx,replace spearman(ignore)

encode secu_code,gen(ID)
xtset ID Year
gen lnSize=ln(FirmSize)
xtreg LeverageRatio Brown Post Treated,re
est store r1
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder,re
est store r2
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year,re
est store r3
xtreg LeverageRatio Brown Post Treated,fe
est store r4
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder,fe
est store r5
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year,fe
est store r6
esttab r1 r2 r3 r4 r5 r6 using Tab3.rtf,se(3) b(3) replace compress nogap keep(Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder _cons)

reg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder
estat vif

xtreg LeverageRatio Brown Post Treated if SOE==0,fe
est store r1
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder if SOE==0,fe
est store r2
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year if SOE==0,fe
est store r3
xtreg LeverageRatio Brown Post Treated if SOE,fe
est store r4
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder if SOE,fe
est store r5
xtreg LeverageRatio Brown Post Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year if SOE,fe
est store r6
esttab r1 r2 r3 r4 r5 r6 using Tab4.rtf,se(3) b(3) replace compress nogap keep(Treated lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder _cons)

tab Year,gen(yr)
forvalues i=1/7{
	gen yr`i'Brown=yr`i'*Brown
	drop yr`i'
}
drop yr3*
xtreg LeverageRatio Brown Post yr* lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year,fe
est store r1
xtreg LeverageRatio Brown Post yr* lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year if SOE==0,fe
est store r2
xtreg LeverageRatio Brown Post yr* lnSize SalesGrowthRate ROArate PowerSepRate HHI5shareholder i.Year if SOE,fe
est store r3
esttab r1 r2 r3 using Tab5.rtf,se(3) b(3) replace compress nogap 










