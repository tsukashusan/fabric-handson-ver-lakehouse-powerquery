クォータ累計 = TOTALQTD(SUM(juchu_meisai[売上]),datetable[Date], ALL('datetable'))

月累計 = TOTALMTD(SUM(juchu_meisai[売上]),datetable[Date], ALL('datetable'))
前年の販売額 = 
		CALCULATE(
			SUM('juchu_meisai'[売上]),
			PARALLELPERIOD('datetable'[Date], -1, YEAR)
		)


前年比 = DIVIDE(SUM(juchu_meisai[売上]) - [前年の販売額], [前年の販売額])


年累計 = TOTALYTD(SUM(juchu_meisai[売上]),datetable[Date], ALL('datetable'), "3/31")


売上金額 = CALCULATE(SUM('juchu_meisai'[売上]))