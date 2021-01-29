let publicAccountSummaryResponse = """
<?xml version=\"1.0\" encoding=\"utf-8\"?>
<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
    <soap:Body>
        <GetBorrowerSummaryResponse xmlns=\"http://bibliomondo.com/websevices/webuser\">
            <GetBorrowerSummaryResult>
                <userId>A577544816</userId>
    <record>
        <GetBorrowerRecordResult xmlns=\"http://bibliomondo.com/webservices/webuser\">
        <Brwr>A577544816</Brwr>
        <WantDefault>0</WantDefault>
        <WantSummary>1</WantSummary>
        <AddType></AddType>
        <IsDefault>0</IsDefault>
        <BrwrNum>A57 754 481 6</BrwrNum>
        <BrwrNumIsEmpty>0</BrwrNumIsEmpty>
        <Renumbered>0</Renumbered>
        <RecordNum>870062</RecordNum>
        <Category>24</Category>
        <CategoryCode>LE</CategoryCode>
        <CategoryName>Erwachsene &gt;27 Last</CategoryName>
        <CategoryType>0</CategoryType>
        <Status>0</Status>
        <AccountBalance>€ 0,00</AccountBalance>
        <BadgeReplacementCharge>€ 0,00</BadgeReplacementCharge>
        <CreditBalance>€ 0,00</CreditBalance>
        <MandatoryCreditBalance>€ 0,00</MandatoryCreditBalance>
        <HaveC210Fields>1</HaveC210Fields>
        <InCredit>0</InCredit>
        <InDebit>0</InDebit>
        <PosAccBal>€ 0,00</PosAccBal>
        <PosAccBalAmount>€ 0,00</PosAccBalAmount>
        <ShowAmountToRefundPopup>0</ShowAmountToRefundPopup>
        <AccBalAsDecimal>0.00</AccBalAsDecimal>
        <PosAccBalAsDecimalUnits>0</PosAccBalAsDecimalUnits>
        <HyphenatedBrwrNum>A57-754-481-6</HyphenatedBrwrNum>
        <NumberOfRes>0</NumberOfRes>
        <NextExpiry>
        <Type>0</Type><Date></Date><Locn>0</Locn><LocnCode>0</LocnCode><LocnName>0</LocnName></NextExpiry><Register><Date>15/08/2014</Date><Locn>1</Locn><LocnCode>1</LocnCode><LocnName>1</LocnName></Register><Subloc><Locn>1</Locn></Subloc><Route><Locn>0</Locn><LocnCode></LocnCode></Route>
        <PseudoForename>Daliia</PseudoForename>
        <StatChange><Date>04/07/2020</Date><Locn>20</Locn><LocnCode>20</LocnCode><LocnName>20</LocnName></StatChange><LastIssue><Date>18/11/2020</Date><Locn>63</Locn><LocnCode>63</LocnCode><LocnName>63</LocnName></LastIssue><AccUpdate><Date>04/07/2020</Date><Locn>20</Locn><LocnCode>20</LocnCode><LocnName>20</LocnName></AccUpdate><CreditUpdate><Date></Date><Locn>0</Locn><LocnCode>0</LocnCode><LocnName>0</LocnName></CreditUpdate><AllowanceType>0</AllowanceType><QuotaGroup>BUE</QuotaGroup><ItemsAllowed><GESAMT>70</GESAMT><BUCHErwachsene>70</BUCHErwachsene><CDs>70</CDs><Videos>10</Videos><CD-ROM>70</CD-ROM><BuchKiJu>70</BuchKiJu><MP3>70</MP3><Konsolensp>10</Konsolensp><Sommerferienprogramm>5</Sommerferienprogramm><Gegenstand>3</Gegenstand></ItemsAllowed><ItemsOnLoan><GESAMT>0</GESAMT><BUCHErwachsene>0</BUCHErwachsene><CDs>0</CDs><Videos>0</Videos><CD-ROM>0</CD-ROM><BuchKiJu>0</BuchKiJu><MP3>0</MP3><Konsolensp>0</Konsolensp><Sommerferienprogramm>0</Sommerferienprogramm><Gegenstand>0</Gegenstand></ItemsOnLoan><TotalIssues>589</TotalIssues><ThisYearIssues>0</ThisYearIssues><LastYearIssues>64</LastYearIssues><YearBefIssues>57</YearBefIssues><OtherIssues>468</OtherIssues>
        <RelNumber></RelNumber>
        <FullName>Dzhumaeva, Daliia</FullName>
        <Notes></Notes>
        <SubsEnabled>1</SubsEnabled>
        <SubsEnabledInRsp>128</SubsEnabledInRsp>
        <LastChange>18/11/2020</LastChange>
        <Owner>1</Owner>
        <OwnerCode>1</OwnerCode>
        <OwnerName>1</OwnerName>
        <CreationDate>15/08/2014</CreationDate>
        <Flag1>48</Flag1>
        <Flag2>0</Flag2>
        <RouteNumber>0</RouteNumber>
        <HaveC200Fields>1</HaveC200Fields>
        <LastReturn>
            <Date>24/11/2020</Date>
            <Locn>1</Locn>
            <LocnCode>1</LocnCode>
            <LocnName>1</LocnName>
        </LastReturn>
        <BirthDate>12/02/1987</BirthDate>
        <LastOverdue></LastOverdue>
        <CurrentSubs>
            <Scheme>6</Scheme>
            <Branch>1</Branch>
            <BranchCode>1</BranchCode>
            <BranchName>  Zentralbibliothek</BranchName>
            <Method>0</Method>
            <Status>1</Status>
            <Amount>€40,00</Amount>
            <IsCharge>1</IsCharge>
            <Change>17/12/2020</Change>
            <Start>18/12/2020</Start>
            <Expiry>17/12/2021</Expiry>
            <StartMonth>12</StartMonth>
            <StartYear>2020</StartYear>
            <ExpiryMonth>12</ExpiryMonth>
            <ExpiryYear>2021</ExpiryYear>
            <SchemeName>Normal Jahr Last</SchemeName>
            <MethodName>
                <ENG>Cash</ENG>
                <GER>Barzahlung</GER>
                <DUT>Contant</DUT>
                <FRE>Monnaie</FRE>
            </MethodName>
            <StatusName>
                <ENG>Paid</ENG>
                <GER>Bezahlt</GER>
                <DUT>Betaald</DUT>
                <FRE>Pay&amp;eacute;</FRE></StatusName></CurrentSubs><NextSubs><Scheme>6</Scheme><Branch>1</Branch><BranchCode>1</BranchCode><BranchName>  Zentralbibliothek</BranchName><Method>0</Method><Status>0</Status><Amount>€ 40,00</Amount><IsCharge>1</IsCharge><Change></Change><Start>18/12/2021</Start><Expiry>17/12/2022</Expiry><StartMonth>12</StartMonth><StartYear>2021</StartYear><ExpiryMonth>12</ExpiryMonth><ExpiryYear>2022</ExpiryYear><SchemeName>Normal Jahr Last</SchemeName><MethodName><ENG>Cash</ENG><GER>Barzahlung</GER><DUT>Contant</DUT><FRE>Monnaie</FRE></MethodName><StatusName><ENG>Not paid</ENG><GER>Nicht bezahlt</GER><DUT>Niet betaald</DUT><FRE>Non pay&amp;eacute;</FRE></StatusName></NextSubs><CurrentExtraSubs><TaxRate>0</TaxRate><TaxAmount>€ 0,09</TaxAmount></CurrentExtraSubs><NextExtraSubs><TaxRate>0</TaxRate><TaxAmount>€ 0,00</TaxAmount></NextExtraSubs><Sex>2</Sex><Nationality>6</Nationality><FirstLang>6</FirstLang><SecondLang>6</SecondLang><Profile>0</Profile><School>0</School><Residence></Residence><Tap>0</Tap><ContactMethod>2</ContactMethod><DepositAmount>€ 0,00</DepositAmount><DepositExpiry></DepositExpiry><DepositPaid>09/09/1999</DepositPaid><Postcode>20255</Postcode><Keys><Pay>2</Pay><Confirm>2</Confirm><Cancel>1</Cancel><Amend>2</Amend><Undo>1</Undo></Keys><Surname>Dzhumaeva</Surname><Forename>Daliia</Forename><Title></Title><Prefix></Prefix><AccountNumber>DE10200505501216474815</AccountNumber><WritingAcNoFromSubs>0</WritingAcNoFromSubs><PassportIdNumber>Dung-Pham, Martin Kim</PassportIdNumber><CommunityRegNumber>HASPDEHHXXX</CommunityRegNumber><EmailAddress>ddzhumaeva@gmail.com</EmailAddress><JobTitle></JobTitle><SchoolNumber></SchoolNumber><NumberOfPupils>0</NumberOfPupils><Fao></Fao><AddressLine1>Lutterothstraße 7</AddressLine1><AddressLine2>Hamburg</AddressLine2><AddressLine3></AddressLine3><AddressLine4></AddressLine4><Country></Country><TelephoneNumber></TelephoneNumber><TelephoneNumberWork></TelephoneNumberWork><MobilePhone></MobilePhone><FaxNumber></FaxNumber><HouseNumber></HouseNumber><HouseLetter></HouseLetter><BoatNumber></BoatNumber><Acronym>DZH12287</Acronym><UserDefinedField1></UserDefinedField1><UserDefinedField2></UserDefinedField2><UserDefinedField3></UserDefinedField3><UserDefinedField1Length>9</UserDefinedField1Length><UserDefinedField2Length>9</UserDefinedField2Length><UserDefinedField3Length>25</UserDefinedField3Length><BirthDateMandatory>1</BirthDateMandatory><LoanHistoryAllowed>0</LoanHistoryAllowed><LoanHistoryRequired>0</LoanHistoryRequired><CreditAllowed>1</CreditAllowed><CreditMandatory>0</CreditMandatory><HouseboundAllowed>0</HouseboundAllowed><HouseboundRequired>0</HouseboundRequired><UseSecondName>0</UseSecondName><UseSecondAddress>0</UseSecondAddress><DetailsIncomplete>0</DetailsIncomplete><AddressChecked>0</AddressChecked><SecondAddressChecked>0</SecondAddressChecked><HaveHouseboundDetails>0</HaveHouseboundDetails><BorrowerMailingList>0</BorrowerMailingList><BorrowerReminders>0</BorrowerReminders><BorrowerDueItemsInfo>0</BorrowerDueItemsInfo><BorrowNationallyOverride>0</BorrowNationallyOverride><BorrowNationallyAllow>0</BorrowNationallyAllow><CurrentDate>23/01/2021</CurrentDate><CurrentTime>19:58</CurrentTime><BranchName>WWW-APP</BranchName><ReadableFullName>Daliia Dzhumaeva</ReadableFullName><Last5DigitsOfBrwrNum>54481</Last5DigitsOfBrwrNum><BirthMonth>2</BirthMonth><BirthYear>1987</BirthYear><Surname_2></Surname_2><Forename_2></Forename_2><Title_2></Title_2><Prefix_2></Prefix_2><Fao_2></Fao_2><AddressLine1_2></AddressLine1_2><AddressLine2_2></AddressLine2_2><AddressLine3_2></AddressLine3_2><AddressLine4_2></AddressLine4_2><Country_2></Country_2><Postcode_2></Postcode_2><TelephoneNumber_2></TelephoneNumber_2><TelephoneNumberWork_2></TelephoneNumberWork_2><MobilePhone_2></MobilePhone_2><FaxNumber_2></FaxNumber_2><EmailAddress_2></EmailAddress_2><JobTitle_2></JobTitle_2><HouseNumber_2></HouseNumber_2><HouseLetter_2></HouseLetter_2><BoatNumber_2></BoatNumber_2></GetBorrowerRecordResult></record>
            </GetBorrowerSummaryResult>
        </GetBorrowerSummaryResponse>
    </soap:Body>
</soap:Envelope>
"""
