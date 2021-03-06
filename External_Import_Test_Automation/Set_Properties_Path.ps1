#Get Local Path

#$Script_Location= Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

$Script_Location= $Env:USERPROFILE +"\TestData"

#Replace CUrrency

$Currency_Import_Properties= $Script_Location+"\Currency\ImportProperties.txt"

$Replace_Content_Currency=$Script_Location+"/Currency/ExternalCurrencyFileImport.csv"

$Replace_Content_Currency= $Replace_Content_Currency -replace ('\\','/')

(get-content $Currency_Import_Properties ) -replace("./Currency/ExternalCurrencyFileImport.csv", $Replace_Content_Currency) | set-content $Currency_Import_Properties

#Replace Currency Escalation

$Currency_Escalation_Import_Properties= $Script_Location+"\CurrencyEscalation\ImportProperties.txt"

$Replace_Content_Escalation=$Script_Location+"/CurrencyEscalation/ExternalCurrencyEscalationFileImport.csv"

$Replace_Content_Escalation= $Replace_Content_Escalation -replace ('\\','/')

(get-content $Currency_Escalation_Import_Properties ) -replace("./CurrencyEscalation/ExternalCurrencyEscalationFileImport.csv", $Replace_Content_Escalation) | set-content $Currency_Escalation_Import_Properties

#Replace Opex_1

$OPEX_Import_Properties= $Script_Location+"\Opex\ImportProperties.txt"

$Replace_Content_OPEX=$Script_Location+"/Opex/ExternalOpexImport.csv"

$Replace_Content_OPEX= $Replace_Content_OPEX -replace ('\\','/')

(get-content $OPEX_Import_Properties ) -replace("./Opex/ExternalOpexImport.csv", $Replace_Content_OPEX) | set-content $OPEX_Import_Properties

#Replace Opex_2

$OPEX_2_Import_Properties= $Script_Location+"\Opex\ImportProperties_2.txt"

$Replace_Content_OPEX_2=$Script_Location+"/Opex/ExternalVariableForecastOpexImport.csv"

$Replace_Content_OPEX_2= $Replace_Content_OPEX_2 -replace ('\\','/')

(get-content $OPEX_2_Import_Properties ) -replace("./Opex/ExternalVariableForecastOpexImport.csv", $Replace_Content_OPEX_2) | set-content $OPEX_2_Import_Properties

#Replace Price Profile

$Price_Import_Properties= $Script_Location+"\PriceProfile\ImportProperties.txt"

$Replace_Content_Price=$Script_Location+"/PriceProfile/ExternalPriceprofilesImport.csv"

$Replace_Content_Price= $Replace_Content_Price -replace ('\\','/')

(get-content $Price_Import_Properties ) -replace("./PriceProfile/ExternalPriceprofilesImport.csv", $Replace_Content_Price) | set-content $Price_Import_Properties

#Replace Price Profile 2

$Price_2_Import_Properties= $Script_Location+"\PriceProfile\ImportProperties_2.txt"

$Replace_Content_Price_2=$Script_Location+"/PriceProfile/WithHeaders-PricesImport.csv"

$Replace_Content_Price_2= $Replace_Content_Price_2 -replace ('\\','/')

(get-content $Price_2_Import_Properties ) -replace("./PriceProfile/WithHeaders-PricesImport.csv", $Replace_Content_Price_2) | set-content $Price_2_Import_Properties