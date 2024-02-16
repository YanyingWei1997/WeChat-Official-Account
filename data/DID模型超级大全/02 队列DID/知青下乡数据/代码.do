
use census_1990_clean.dta,clear

*******************Standard cohort DID估计
gen treat = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969) //划分处理组和控制组

reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==1, absorb(region1990 prov#year_birth c.primary_base#year_birth c.junior_base#year_birth) cluster(region1990)



*******************Reduced-Form cohort DID估计

forvalues y = 1946/1969 {
	gen I`y' = sdy_density*[year_birth==`y']
}

reghdfe yedu I1946-I1969 male han_ethn if rural==1, absorb(region1990 prov#year_birth c.primary_base_older#year_birth c.junior_base_older#year_birth) cluster(region1990)



*-绘图
coefplot, baselevels ///
keep(I19*) ///
vertical ///转置图形
coeflabels(I1946=1946 I1947=1947 I1948=1948 I1949=1949 I1950=1950 ///
I1951=1951 I1952=1952 I1953=1953 I1954=1954 I1955=1955 I1956=1956 ///
I1957=1957 I1958=1958 I1959=1959 I1960=1960 I1961=1961 I1962=1962 ///
I1963=1963 I1964=1964 I1965=1965 I1966=1966 I1967=1967 I1968=1968 ///
I1969=1969) /// 
yline(0,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
xline(10,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
ylabel(-4(2)8,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75) angle(45)) ///
ytitle("Coefficients") ///
xtitle("Birth cohort") ///
msymbol(O) msize(small) mcolor(gs1) ///plot样式
addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ///增加点之间的连线
ciopts(recast(rline) lwidth(thin) lpattern(dash) lcolor(gs2)) ///置信区间样式
graphregion(color(white)) //白底
graph save fig1,replace 





*-变换样式
coefplot, baselevels ///
keep(I19*) ///
vertical ///转置图形
coeflabels(I1946=1946 I1947=1947 I1948=1948 I1949=1949 I1950=1950 ///
I1951=1951 I1952=1952 I1953=1953 I1954=1954 I1955=1955 I1956=1956 ///
I1957=1957 I1958=1958 I1959=1959 I1960=1960 I1961=1961 I1962=1962 ///
I1963=1963 I1964=1964 I1965=1965 I1966=1966 I1967=1967 I1968=1968 ///
I1969=1969) /// 
yline(0,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
xline(10,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
ylabel(-4(2)8,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75) angle(45)) ///
ytitle("Coefficients") ///
xtitle("Birth cohort") ///
msymbol(O) msize(small) mcolor(gs1) ///plot样式
addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ///增加点之间的连线
ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2)) ///置信区间样式
graphregion(color(white)) //白底
graph save fig2,replace

coefplot, baselevels ///
keep(I19*) ///
vertical ///转置图形
coeflabels(I1946=1946 I1947=1947 I1948=1948 I1949=1949 I1950=1950 ///
I1951=1951 I1952=1952 I1953=1953 I1954=1954 I1955=1955 I1956=1956 ///
I1957=1957 I1958=1958 I1959=1959 I1960=1960 I1961=1961 I1962=1962 ///
I1963=1963 I1964=1964 I1965=1965 I1966=1966 I1967=1967 I1968=1968 ///
I1969=1969) /// 
yline(0,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
xline(10,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
ylabel(-4(2)8,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75) angle(45)) ///
ytitle("Coefficients") ///
xtitle("Birth cohort") ///
msymbol(O) msize(small) mcolor(gs1) ///plot样式
addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ///增加点之间的连线
ciopts(recast(rarea) color(gs10)) ///置信区间样式
graphregion(color(white)) //白底
graph save fig3,replace

coefplot, baselevels ///
keep(I19*) ///
vertical ///转置图形
coeflabels(I1946=1946 I1947=1947 I1948=1948 I1949=1949 I1950=1950 ///
I1951=1951 I1952=1952 I1953=1953 I1954=1954 I1955=1955 I1956=1956 ///
I1957=1957 I1958=1958 I1959=1959 I1960=1960 I1961=1961 I1962=1962 ///
I1963=1963 I1964=1964 I1965=1965 I1966=1966 I1967=1967 I1968=1968 ///
I1969=1969) /// 
yline(0,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
xline(10,lwidth(vthin) lpattern(solid) lcolor(teal)) ///
ylabel(-4(2)8,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75) angle(45)) ///
ytitle("Coefficients") ///
xtitle("Birth cohort") ///
msymbol(O) msize(small) mcolor(gs1) ///plot样式
addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ///增加点之间的连线
ciopts(recast(rcapsym) lwidth(thin) lpattern(dash) lcolor(gs2) color(gs6)) ///置信区间样式
graphregion(color(white)) //白底
graph save fig4,replace

graph combine fig1.gph fig2.gph fig3.gph fig4.gph, graphregion(color(white))
