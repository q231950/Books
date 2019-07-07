let publicLoanDetailResponseBody = """
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Body>
        <GetCatalogueRecordResponse xmlns="http://bibliomondo.com/websevices/webcatalogue">
            <GetCatalogueRecordResult>
                <xmlDoc>
                    <GetCatalogueRecordResult xmlns="http://bibliomondo.com/webservices/webcatalogue">
                        <SaopAction>GetCatalogueRecord</SaopAction>
                        <StatusCode>0</StatusCode>
                        <StatusMessage>OK</StatusMessage>
                        <SoapActionResult>
                            <Key>T01540384X</Key>
                            <KeyType>1</KeyType>
                            <SynCount>1</SynCount>
                            <IsEAN>0</IsEAN>
                            <IncrVarient>Delta</IncrVarient>
                            <LockForAmend></LockForAmend>
                            <AddRecord></AddRecord>
                            <CloneRecord></CloneRecord>
                            <CreateIssue></CreateIssue>
                            <AddShort></AddShort>
                            <SpinePrint></SpinePrint>
                            <HavePermissionToAmend>0</HavePermissionToAmend>
                            <KeepLocked>True</KeepLocked>
                            <ISPROV>0</ISPROV>
                            <IsFull>1</IsFull>
                            <PrintCollections>0</PrintCollections>
                            <Author>Ferguson Smart, John</Author>
                            <Title>Jenkins: the definitive guide</Title>
                            <ClassMark>Jd 0#FERG•/21 Jd 0</ClassMark>
                            <BACBAC>T01540384X</BACBAC>
                            <CorpAuthor></CorpAuthor>
                            <IsConceptual>False</IsConceptual>
                            <IsLocked>False</IsLocked>
                            <IsNewRecord>False</IsNewRecord>
                            <BACCNO>978 1 44930535 2</BACCNO>
                            <BACREL></BACREL>
                            <BACISB>978 1 44930535 2</BACISB>
                            <EANSTR></EANSTR>
                            <MaterialType>1</MaterialType>
                            <MaterialTypeName>Buch Erwachsene</MaterialTypeName>
                            <InterestLevel>2</InterestLevel>
                            <InterestLevelName>Erw.Sachb.</InterestLevelName>
                            <BACATK>FSMJJENK</BACATK>
                            <BACTKY>JENKINS </BACTKY>
                            <BACEDI>1</BACEDI>
                            <BACYER>2011</BACYER>
                            <BACDAI>03/01/2012</BACDAI>
                            <BACDAF>03/01/2012</BACDAF>
                            <BACSCB>1</BACSCB>
                            <BACSCF>1</BACSCF>
                            <Format>10</Format>
                            <Owner>1</Owner>
                            <BACOWN>   Zentralbibliothek</BACOWN>
                            <BACECA></BACECA>
                            <BACVOP>0</BACVOP>
                            <BACVO3>0</BACVO3>
                            <BACVO4>0</BACVO4>
                            <BACVOL>0</BACVOL>
                            <BACVOF>0</BACVOF>
                            <BACPRI>€ 36,50</BACPRI>
                            <BACPAR></BACPAR>
                            <BACSYN>1</BACSYN>
                            <BACMET>0</BACMET>
                            <NewAdd>0</NewAdd>
                            <LanguageText>7</LanguageText>
                            <LanguageTitle>0</LanguageTitle>
                            <OriginalLanguage>7</OriginalLanguage>
                            <BACDLC>20/01/2012</BACDLC>
                            <BACINI></BACINI>
                            <BACCOL>0</BACCOL>
                            <BACDFA>20/01/2012</BACDFA>
                            <BACTPV>0</BACTPV>
                            <MAXSYN>1</MAXSYN>
                            <HLEVEL>1</HLEVEL>
                            <HTYPE>1</HTYPE>
                            <SERIAL>0</SERIAL>
                            <ISSUE>0</ISSUE>
                            <Notes></Notes>
                            <Publisher></Publisher>
                            <Series></Series>
                            <Subject></Subject>
                            <BACISBISMISS>9781449305352</BACISBISMISS>
                            <SpineLabelLine1></SpineLabelLine1>
                            <SpineLabelLine2></SpineLabelLine2>
                            <SpineLabelLine3></SpineLabelLine3>
                            <SpineLabelLine4></SpineLabelLine4>
                            <SpineLabelLine5></SpineLabelLine5>
                            <Tags>
                                <Block_0>
                                    <__Element__ name="007">
                                        <INDS></INDS>
                                        <TEXT>tu ||||||||||||||||||||</TEXT>
                                    </__Element__>
                                    <__Element__ name="008">
                                        <INDS></INDS>
                                        <TEXT>120103|2011||||||||||||</TEXT>
                                    </__Element__>
                                    <__Element__ name="020">
                                        <INDS></INDS>
                                        <__Element__ name="$a">9781449305352</__Element__>
                                        <__Element__ name="$c">kart. : EUR 36,50</__Element__>
                                        <__Element__ name="$9">978-1-449-30535-2</__Element__>
                                    </__Element__>
                                    <__Element__ name="100">
                                        <INDS>1 </INDS>
                                        <__Element__ name="$a">Ferguson Smart, John </__Element__>
                                    </__Element__>
                                    <__Element__ name="245">
                                        <INDS>10</INDS>
                                        <__Element__ name="$a">Jenkins: the definitive guide</__Element__>
                                        <__Element__ name="$c">John Ferguson Smart </__Element__>
                                    </__Element__>
                                    <__Element__ name="250">
                                        <INDS></INDS>
                                        <__Element__ name="$a">1st. ed.</__Element__>
                                    </__Element__>
                                    <__Element__ name="260">
                                        <INDS>3 </INDS>
                                        <__Element__ name="$a">Beijing [u.a.] </__Element__>
                                        <__Element__ name="$b">O'Reilly</__Element__>
                                        <__Element__ name="$c">2011</__Element__>
                                    </__Element__>
                                    <__Element__ name="300">
                                        <INDS></INDS>
                                        <__Element__ name="$a">XXII, 380 S.</__Element__>
                                        <__Element__ name="$b">Ill., graph. Darst.</__Element__>
                                    </__Element__>
                                    <__Element__ name="650">
                                        <INDS>00</INDS>
                                        <__Element__ name="$a">Jenkins CI</__Element__>
                                    </__Element__>
                                    <__Element__ name="689">
                                        <INDS>00</INDS>
                                        <__Element__ name="$a">Jenkins CI</__Element__>
                                        <__Element__ name="$A">s</__Element__>
                                    </__Element__>
                                    <__Element__ name="852">
                                        <INDS></INDS>
                                        <__Element__ name="$c">Jd 0#FERG•/21 Jd 0</__Element__>
                                    </__Element__>
                                    <__Element__ name="852">
                                        <INDS></INDS>
                                        <__Element__ name="$c">Jd 0#FERG</__Element__>
                                    </__Element__>
                                    <__Element__ name="852">
                                        <INDS></INDS>
                                        <__Element__ name="$c">Jd 0</__Element__>
                                    </__Element__>
                                    <__Element__ name="852">
                                        <INDS></INDS>
                                        <__Element__ name="$c">21 Jd 0</__Element__>
                                    </__Element__>
                                </Block_0>
                            </Tags>
                            <BACMAT>Buch Erwachsene</BACMAT>
                            <BACIMC>Erw.Sachb.</BACIMC>
                            <BACLTX>englisch</BACLTX>
                            <BACLTI></BACLTI>
                            <BACORG>englisch</BACORG>
                            <PreviousSig></PreviousSig>
                            <STATUS>1</STATUS>
                            <SRSSTATUS>0</SRSSTATUS>
                            <SRSRequests>0</SRSRequests>
                            <HASHVOL>0</HASHVOL>
                            <HASWORKS>0</HASWORKS>
                            <HASPARAT>0</HASPARAT>
                            <HASPARAUTHOR>0</HASPARAUTHOR>
                            <HASPARTITLE>0</HASPARTITLE>
                            <HVOL>0</HVOL>
                            <WORKS>0</WORKS>
                            <PARAUTHOR></PARAUTHOR>
                            <PARTITLE></PARTITLE>
                            <IsPRD>False</IsPRD>
                            <LinkISBN>978 1 44930535 2</LinkISBN>
                            <UserReviews></UserReviews>
                        </SoapActionResult>
                    </GetCatalogueRecordResult>
                </xmlDoc>
            </GetCatalogueRecordResult>
        </GetCatalogueRecordResponse>
    </soap:Body>
</soap:Envelope>
""".data(using: .utf8)
