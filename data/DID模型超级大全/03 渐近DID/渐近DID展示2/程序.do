
use 表1,clear
****附录表2变量描述性统计结果
sum gdpr did invest consume export gov second agg innov
****正文表1的结果
xtset id year
xtreg gdpr did i.year,fe cluster(id)
xtreg gdpr did invest consume export gov second agg innov i.year, fe cluster(id)
****正文表2的结果
use 表2,clear
xtset id year
xtreg gdpr did did01 invest consume export gov second agg innov i.year, fe cluster(id)
xtreg gdpr did did02 invest consume export gov second agg innov i.year, fe cluster(id)
xtreg gdpr did did01 did02 invest consume export gov second agg innov i.year, fe cluster(id)
****正文表3的结果
use 表3-1,clear //表3模型1
xtset id year
xtreg gdpr did invest consume export gov second agg innov i.year, fe cluster(id)
use 表3-2,clear //表3模型2
xtset id year
xtreg gdpr did invest consume export gov second agg innov i.year, fe cluster(id)
use 表1,clear //表3模型3
winsor gdpr,p(0.01) gen(gdpr02)
xtset id year
xtreg gdpr02 did invest consume export gov second agg innov i.year, fe cluster(id)
use 表3-4,clear //表3模型4与模型5
reghdfe gdpr did invest consume export gov second agg innov,ab(province year) vce(cluster id)
reghdfe gdpr did invest consume export gov second agg innov,ab(i.province#i.year province year id) vce(cluster id)
****正文表4的结果
use 表4-1,clear
xtset id year
gen inter=did*gdpr0
xtreg gdpr did inter invest consume export gov second agg innov i.year, fe cluster(id)
sum gdpr0,d
lincom did + 11.5*inter
lincom did + 13.4*inter
lincom did + 15*inter
use 表4-2,clear
xtset id year
gen inter=did*gdpr0
xtreg gdpr did inter invest consume export gov second agg innov i.year, fe cluster(id)
sum gdpr0,d
lincom did + 12.45*inter
lincom did + 13.85*inter
lincom did + 15.25*inter
use 表4-3,clear
xtset id year
gen inter=did*gdpr0
xtreg gdpr did inter invest consume export gov second agg innov i.year, fe cluster(id)
sum gdpr0,d
lincom did +11.47*inter
lincom did +13.77*inter
lincom did +15.23*inter
****正文表5的结果
use 表5,clear
xtset id year
gen inter=did*instu0
xtreg gdpr did inter i.year, fe cluster(id) 
sum instu0 if instu0>0,d
lincom did +0.41*inter
lincom did +0.53*inter
lincom did +0.65*inter
xtreg gdpr did inter invest consume export gov second agg innov i.year, fe cluster(id)
lincom did +0.41*inter
lincom did +0.53*inter
lincom did +0.65*inter
****正文表6的结果
use 表6,clear
xtset id year
xtreg tfpr did invest consume export gov second agg innov i.year, fe cluster(id)
xtreg lr did invest consume export gov second agg innov i.year, fe cluster(id)
xtreg kr did invest consume export gov second agg innov i.year, fe cluster(id)
xtreg fr did invest consume export gov second agg innov i.year, fe cluster(id)
****正文表7的结果
use 表7,clear
xtset id year
xtreg gdpr did invest consume export gov second agg innov i.year if d_area==1 | treat==0, fe cluster(id)
xtreg gdpr did invest consume export gov second agg innov i.year if d_area==2 | treat==0, fe cluster(id)
xtreg gdpr did invest consume export gov second agg innov i.year if d_area==3 | treat==0, fe cluster(id)
xtreg gdpr did invest consume export gov second agg innov i.year if d_area==4 | treat==0, fe cluster(id)
xtreg gdpr did invest consume export gov second agg innov i.year if d_area==5 | treat==0, fe cluster(id)
****正文表8的结果
use 表8,clear
xtset id year
xtreg gdpr did n200 invest consume export gov second agg innov i.year if cross==0 | treat==0, fe cluster(id)
xtreg gdpr did n200 invest consume export gov second agg innov i.year if cross==1 | treat==0, fe cluster(id)
xtreg m_gdpr01 did n200 invest consume export gov second agg innov i.year if cross==1 | treat==0, fe cluster(id)
xtreg m_gdpr02 did n200 invest consume export gov second agg innov i.year if cross==1 | treat==0, fe cluster(id)

****正文图1的结果
use 图1,clear
xtset id year
xtreg gdpr d_8-d_2 d0-d8 invest consume export gov second agg innov i.year,fe cluster(id)
coefplot, keep(d*)  coeflabels(d_8="-8" d_7="-7" d_6="-6" d_5="-5" d_4="-4" d_3="-3" d_2="-2"   d0="0"    ///
d1="1"  d2="2"  d3="3"  d4="4"  d5="5"  d6="6"  d7="7"  d8="8")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("相对于国家级新区成立的时间（年）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))

****正文图2的结果
use 图2,clear
xtset id year
xtreg gdpr did0 c_did50-c_did400 invest consume export  gov second agg innov i.year, fe cluster(id)
coefplot, keep(did0 c_did*)  coeflabels(did0="0" c_did50="50" c_did100="100" c_did150="150" c_did200="200" c_did250="250" c_did300="300" c_did350="350" c_did400="400")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("空间距离（千米）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))



****附录图1的结果
use 附图1,clear
keep if year>2002
xtset id year
xtreg gdpr d_8-d_2 d0-d8 invest consume export  gov second agg innov i.year,fe cluster(id)
coefplot, keep(d*)  coeflabels(d_8="-8" d_7="-7" d_6="-6" d_5="-5" d_4="-4" d_3="-3" d_2="-2"   d0="0"    ///
d1="1"  d2="2"  d3="3"  d4="4"  d5="5"  d6="6"  d7="7"  d8="8")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("相对于国家级新区成立的时间（年）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))

****附录图2的结果
use 附图1,clear
xtset id year
xtreg gdpr d_8-d_2 d0-d8 invest consume export  gov second agg innov i.year,fe cluster(id)
coefplot, keep(d*)  coeflabels(d_8="-8" d_7="-7" d_6="-6" d_5="-5" d_4="-4" d_3="-3" d_2="-2"   d0="0"    ///
d1="1"  d2="2"  d3="3"  d4="4"  d5="5"  d6="6"  d7="7"  d8="8")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("相对于国家级新区成立的时间（年）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))

****附录图3的结果
use 附图3,clear
xtset id year
xtreg gdpr did0 c_did100-c_did400 invest consume export  gov second agg innov i.year, fe cluster(id)
coefplot, keep(did0 c_did*)  coeflabels(did0="0" c_did100="100" c_did150="150" c_did200="200" c_did250="250" c_did300="300" c_did350="350" c_did400="400")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("空间距离（千米）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))

****附录图4的结果
use 附图4,clear
xtset id year
xtreg gdpr did0 c_did150-c_did400 invest consume export  gov second agg innov i.year, fe cluster(id)
coefplot, keep(did0 c_did*)  coeflabels(did0="0" c_did150="150" c_did200="200" c_did250="250" c_did300="300" c_did350="350" c_did400="400")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("空间距离（千米）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))
****附录图5的结果
use 附图5,clear
xtset id year
xtreg gdpr did0 c_did100-c_did400 invest consume export  gov second agg innov i.year, fe cluster(id)
coefplot, keep(did0 c_did*)  coeflabels(did0="0" c_did100="100"  c_did200="200"  c_did300="300"  c_did400="400")    ///
vertical  addplot(line @b @at) ytitle("GDP增长率（%）") xtitle("空间距离（千米）")yline(0) levels(90) scheme(s1mono) ciopts(recast(rcap) lpattern(dash))
****附录图6、图7与图8的结果
use 附图6,clear
sum b_did
kdensity b_did,normal scheme(s1mono)
use 附图7,clear
sum b_did
kdensity b_did,normal scheme(s1mono)
use 附图8,clear
gen diff=b2_did0-b1_did0
kdensity diff,normal scheme(s1mono)
ttest diff==0.14

****附录表3的结果
use 附表3,clear
gen life=year-2002
gen death=.
replace death=1 if id==2 & year==2005
replace death=1 if id==35 & year==2014
replace death=1 if id==48 & year==2015
replace death=1 if id==56 & year==2015
replace death=1 if id==69 & year==2015
replace death=1 if id==90 & year==2011
replace death=1 if id==109 & year==2015
replace death=1 if id==118 & year==2016
replace death=1 if id==121 & year==2016
replace death=1 if id==130 & year==2014
replace death=1 if id==175 & year==2014
replace death=1 if id==188 & year==2012
replace death=1 if id==225 & year==2009
replace death=1 if id==226 & year==2014
replace death=1 if id==237 & year==2014
replace death=1 if id==244 & year==2013
replace death=1 if id==247 & year==2013
replace death=1 if id==248 & year==2015
replace death=1 if id==256 & year==2013
replace death=1 if id==259 & year==2013
replace death=1 if id==266 & year==2012
replace death=0 if id==2 & year<2005
replace death=0 if id==35 & year<2014
replace death=0 if id==48 & year<2015
replace death=0 if id==56 & year<2015
replace death=0 if id==69 & year<2015
replace death=0 if id==90 & year<2011
replace death=0 if id==109 & year<2015
replace death=0 if id==118 & year<2016
replace death=0 if id==121 & year<2016
replace death=0 if id==130 & year<2014
replace death=0 if id==175 & year<2014
replace death=0 if id==188 & year<2012
replace death=0 if id==225 & year<2009
replace death=0 if id==226 & year<2014
replace death=0 if id==237 & year<2014
replace death=0 if id==244 & year<2013
replace death=0 if id==247 & year<2013
replace death=0 if id==248 & year<2015
replace death=0 if id==256 & year<2013
replace death=0 if id==259 & year<2013
replace death=0 if id==266 & year<2012
drop if death==.
stset life death, id(id)
streg gdpr pgdp gdp invest consume export  gov second agg innov, cluster(id) dist(weibull) time
****附录表4与表5的结果
use 附表4-5,clear
forvalues i=2003(1)2017 {
qui use 附表4-5,clear
qui keep if year==`i'
qui set seed 0001 //定义种子
qui gen tmp = runiform() //生成随机数
qui sort tmp //把数据库随机整理
qui psmatch2 treat gdp pgdp invest consume export  gov second agg innov, logit ate neighbor(1) common //通过近邻匹配
qui gen common=_support
qui drop if common == 0  //去掉不满足共同区域假定的观测值
pstest gdp pgdp invest consume export  gov second agg innov, raw treated(treat)   // 查看处理组与控制组随机化的效果 循环生成附录表4的内容
qui save psm`i',replace
}
use psm2003,clear
save psm,replace
forvalues i=2004(1)2017 {
use psm,clear
append using psm`i'
save psm,replace
}
use psm,clear
gen did=0
replace did=1 if id==2 & year>2004
replace did=1 if id==35 & year>2013
replace did=1 if id==48 & year>2014
replace did=1 if id==56 & year>2014
replace did=1 if id==69 & year>2014
replace did=1 if id==90 & year>2010
replace did=1 if id==109 & year>2014
replace did=1 if id==118 & year>2015
replace did=1 if id==121 & year>2015
replace did=1 if id==130 & year>2013
replace did=1 if id==175 & year>2013
replace did=1 if id==188 & year>2011
replace did=1 if id==225 & year>2008
replace did=1 if id==226 & year>2013
replace did=1 if id==237 & year>2013
replace did=1 if id==244 & year>2012
replace did=1 if id==247 & year>2012
replace did=1 if id==248 & year>2014
replace did=1 if id==256 & year>2012
replace did=1 if id==259 & year>2012
replace did=1 if id==266 & year>2011
xtset id year
xtreg gdpr did invest consume export gov second agg innov i.year, fe cluster(id) //附录表5的结果


