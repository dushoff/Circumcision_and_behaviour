May 7th 2017

Always put new notes at the top. Recency project wants to change "Other Christian to Christian".




Ten countries (Kenya, Lesotho, Malawi, Mozambique, Namibia, Rwanda, Tanzania, Uganda, Zambia and Zimbabwe) participating in the WHO's VMMC scale-up with available data from the Demographic and Health Surveys (DHS) were analyzed.  We did not use Tanzania 2014 (TZ7) because it missed religion and HIV knowledge.

In surveys.Rout, there are 12570 NAs in MCCategory.  It is the sum of circumcised men in the pre-2007 datasets.

  
Number of non-marital sexual partners within the last 12 months was recoded from zero to three; and number of non marital sexual partners in lifetime from zero to six. Numbers exceeded the maximum was truncated as the maximum.  

== To Do (2) ==

* CLEAN UP THESE NOTES
* Now that we have CC as a fixed effect, we have to deal with TZ6 religion.. Not sure how to average given TZ4 has religion data


== To Do ==

* Clean up these notes
  * Move note stuff from README to here!

* Work on refs! The ambiguities are real.
  * The $#@! does this mean? Did we fix this?

== What does this mean? ==

* Shall we apply our results like in these  [[Mixed_models/examples | figures]]?
* redo table with LS


== To Discuss ==
* Can we present part of our results by region as the [http://www.plosmedicine.org/article/info:doi/10.1371/journal.pmed.1001626 Pulliin's GPS paper] did?
* We need to look at the interaction effect of religion and MC status on risk behaviors.
* Like to tear apart [[MC_risk_Africa_gender | gender]] in the couple data to gain some ideas of women's role in MC risk.  Chyun is working on it.
* What do we do with Tazania in religion?  What does it mean to "average" it?


== To Be Noted ==
* Only samples aged 15-49 were included in our study (in response to UN's prioritized targets).
* We recoded people who don't know about HIV protection as NAs, and it produced more than xx,000 NAs.  The variable is no longer usable and not in our recode.  We need to check again all the NAs.
* The reason why there are more than 23,000 NAs in partnerLife is because many of the pre-2007 surveys did not include this variable.

== Meeting Note ==

* July 13

+ Mike will get CI P values.  Chyun will update her MS notes.

* Mon Jul 11 

+ in the evening:  We over-ruled the decision early today and decided to add media to the random slopes.

+ duirng the day:  We are not adding random slopes because we don't have the power to do all of
them, and we don't want to choose some at random. This means, in part, that our
inferences about slopes are more limited (and certainly don't try to go beyond
the countries whose surveys we are using).

* 5/26/14
+ There are too many NAs in the model results.  So we decided to run some tests to diagonosis the problem and also compare the results.  It can give us some ideas what might cause the problem and how different those results are.  We decided to run 4 testing models:  without religion, without Tanzania, without AQG, and treating region as random factor

* 1/16/14
+ To include all the HIV+ smaples
+ To use 2007 as the cut-off, and treat 2007 as old surveys.
+ To include only men aged 15-49 to reflect the prioritized MC population recommended by UN.

* 10/25

+ We decide to add whoLastSex as an "ordinal" response. (10/25)
+ We recoded partnerYear and partnerLife and made 3 and 6 the maximum (changed from 2 and 5) (10/25)
+ Both of Lesotho surveys are excluded from the MC status model because there is no condom variable in Lesotho 4. (10/25)
+ We decided to throw away all the samples never with sex in their life. (10/28)

* 10/28

+ Exclude everyone with no lifetime sex at the beginning
+ Going to look at patterns of people with one partner to evaluate how to model partnerYear as a risk behaviour
+ Also look at two partners?
+ We will use recentSex (V536: Recent sexual activity) as the criteria to select samples for partnerYear.  recentSex is based on  No. V613 (Never had sexual intercourse) in DHS manual VI.

* 7/17/16
make variable base p-values


* 8/9/16
- change order "now", "old", "plot"
- variable level pvalues on label
- interaction coeff confint (relative odds ratio) 
 
== Orphan notes ==

CF:{"As Rwanda endeavours to reach its goal of having 50 percent men clinically circumcised by June 2013, as part of HIV prevention efforts, over 20,000 men have been circumcised since the campaign began in October 2010." [@[http://allafrica.com/stories/201202200020.html Rwanda: Over 20,000 Circumcised Since October] access Jun 25; @12]}
CF:{early resumption of sex before wounds healed [@HeweHall12].}

### = from Uganda ==


"The recency results showed a trend for newly circumcised men to report more sexual partners than those circumcised before 2008, who in turn reported more than uncircumcised men (See +@fig:AIS_combinedPartner); the difference was particularly clear in terms of numbers of non-marital sexual partners within the preceding 12 months. This result is supported by a qualitative study of men circumcised in the previous 12 months in Swaziland [@GrunHenn12] and by a cross-sectional study of traditionally circumcised men in Cape Town, South Africa [@EatoCain11], as well as the follow-up Rakai study [@KongSsek14] and another study based on Uganda AIS, which also showed that circumcised men had more lifetime sexual partners than uncircumcised men [@KibiNans14]. Other studies found no such effect [@AuveTalj05; @AgotKiar07; @BailMose07; @GrayKigo07; @MattCamp08; @GrayKigo12; @KongKigo12; @GalbOchi14], including two of the Rakai posttrial studies [@GrayKigo12; @KongKigo12]."

A possibility of an increase of sexual transmitted infection will be expected if women falsely believed that they were directly protected from HIV infection [@LayeBeck13; @MaugBren13], hence less likely to negotiate for safe sex [@].  That can impact the MMC efficacy and even adversely increase woman's HIV risk in the long term if SRC reaches a threshold [@DushPato11; @KaliEato07]CF:{more cites}.  CF:{pro and con in [@JoneCrem14]}.  In terms of MC knowledge, it was found that both men and women believed that MC directly reduced the risk of HIV infection for women [@MaugVenk13; @MaugGodl14].  "incorrectly believed MC is fully protective for men against HIV. Women also greatly overestimated the protection MC offers against STIs. The proportion of women who believed MC reduces a woman's HIV risk if she has sex with a man who is circumcised increased significantly "[@HabeKell16]

There is more; see Uganda manuscript.

![Interaction plot showing the mean effect of MC Status on condom use, and the interaction with DHS survey year.  Interaction P=0.019.](figdrop/condomRecency_MCcat.Rout.pdf){#fig:DHS_condom_interaction}
condomRecency_MCcat.pdf

![Interaction plot showing the mean effect of MC Status on condom use, and the interaction with DHS survey year.  Interaction P=0.019.](figdrop/condom.intYear.Rout.pdf){#fig:DHS_condom_interaction}

We found a significant interaction between circumcision status and condom use, but not for numbers of non-marital sexual partners of year nor of lifetime partners (\tref{ptable}). The pattern for the condom use  is shown in +@fig:DHS_condom_interaction.   The "relative" odds of a circumcised man (compared to an uncircumcised man) using a condom are significantly lower in 2011 than in 2006 (the relative odds ratio (ROR) is 0.56 (95% CI, 0.35--0.91; P=0.019)).  This result supports the concerns of sexual risk compensation (SRC).

For lifetime partners, we found an almost-significant interaction (P=0.054) \emph{opposite} to the predicted direction (+@fig:DHS_life_interaction).  It is worth noting, however, that reported number of lifetime partners changed sharply between the two surveys (see Supplementary File 1) and may be subject to recall bias.  No significant interaction was found for non-marital partners within a year (+@fig:DHS_year_interaction). The range of possible effects corresponding to our estimates for SRC (of uncertain direction) is shown in \tref{partnerMath} in the Appendix.

The variable-level significance of co-factors is summarized in \tref{ptable}, and the patterns of how each risk behavior responds to these predictors are shown in the Supplementary File 1.   CF:{briefly mentioned the results.  For example, media use and martial.  I myself is confused with the results:  does it mean that media use is "positively" correlated with risk behaviour?  And marital status?}

====
Circumcision can be used by men to argue that safe sex is not necessary [@AbboHabe13], especially if women also believe that circumcision protect both sides from HIV risk [@LayeBeck13; @MaugVenk13].  The overall, long-term effects of MMC campaigns on women needs further study [@HallSing08; @AlsaCash09; @WaweMaku09; @WeisHank09; @DushPato11], particularly since gender power relationships and gender violence may contribute to women's HIV risk [@DunkJewk04a; @SilvDeck08; @Jewk10a; @Dude11; @ShiKouy13].  MMC campaign therefore need to also reach out to women, particularly women in high risk groups.

Refer to [@DickTran11; @SgaiReed14] in their findings and suggestions on tackling the MMC obstacle and improving MMC campaign effeciency.

= By nations:

Kenya: [@GrunHenn12; @WestAgot14] (RiesAchi10)) http://www.ncbi.nlm.nih.gov/pubmed/27632232 (WestJoak16)
Lesotho:
Malawi:
Mozambique:
Namibia:
Rwanda:
Tanzania:
Uganda: [@GrayKigo12; @KibiSand16 ; @KongKigo12] found no SRC, but not [@KibiNans14]
Zombia:
Zimbabwe: [@ChikMaha15]

Let's try to do 2 projects:
1. analyzing all the countries after the UN's MMC recommendation
2. analyzing Kenya only; or with Namibia and Tanzania (and maybe Ugana) to compare the differences before and after the recommendation.

* to add kemr70, nmmr61, nmmr51, zmmr61, zmmr51

Why no BESS? No access to Botswana.; Ethiopia 2005 did not have information of age when men were circumcised; South Africa has only 1998 Survey, and Swaziland has only 2006-7 survey. 
* surveys of DHS IV.  The rest were between DHS V vs. VI.
* How do we decide which survey to use between DHS IV vs. V?

-Kenya:  2003.IV vs. 2014.VII (2008-9 DHS V is available) (20xx vs. 2014.  By 2014, the VMMC prevalence was 108%, percentage of progress towards targets set in 2011 ) [@WHO16]
-Lesotho: 2004.IV vs. 2014.VII ( 0% vs. 23%)
-Malawi: 2004.IV vs. 2010.VI ( 8% vs. 8%)
-Mozambique: 2003.IV vs. 2011.VI ( 5% vs. 53%)
-Namibia:  2006-7.V vs. 2013.VI (newly added) ( 6% vs. 6%)
-Rwanda: 2005.V vs. 2014-5.VII ( 0.4% vs. ?%)
-Tanzania: 2004-5.IV vs. 2010.VI (2003-4 AIS vs. 2011-2 AIS)  (to use 2007-8 DHS V?) ( 1% vs. 89%)
-Uganda: 2006.V vs. 2011.VI (AIS and DHS in 2011) ( 4% vs. 59%)
-Zambia:  2007.V vs. 2013-4.VI (newly added) ( 49%)
-Zimbabwe: 2005-6.V vs. 2011.VI ( 9% vs. 22%)
(10: KLMMNRTUZZ; no 4: Botswana, Ethiopia, South Africa and Swaziland (BESS)

== Suggested Reviewers ==
* Brendan Maughan-Brown, Senior Research Officer University of Cape Town . Southern Africa Labour and Development Research Unit (SALDRU)
