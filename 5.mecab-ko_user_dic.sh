
https://bitbucket.org/eunjeon/mecab-ko-dic/src/5fad4609d23a1b172a57e23addfe167ac5f02bf1/final/user-dic/README.md?fileviewer=file-view-default

mecab-ko를 설치하고 사용자 dic를 추가 설치할수 있다.

사용자 사전 추가
준비
 mecab-ko와 mecab-ko-dic 을 다운받아 설치합니다.
 mecab-ko-dic 을 꼭 컴파일까지 하셔야 이후에 사전 추가가 가능합니다.

사전 추가
내려받은 mecab-ko-dic/userdic 디렉토리 안에 csv 확장자로 사전 파일을 추가합니다.
userdic/
├── nnp.csv
├── person.csv
└── place.csv


#일반적인 고유명사 추가
대우,,,,NNP,*,F,대우,*,*,*,*
구글,,,,NNP,*,T,구글,*,*,*,*

#인명 추가
까비,,,,NNP,인명,F,까비,*,*,*,*

#지명 추가
세종,,,,NNP,지명,T,세종,*,*,*,*
세종시,,,,NNP,지명,F,세종시,Compound,*,*,세종/NNP/지명+시/NNG/*

그 외의 품사 추가가 필요한 경우에는 품사태그표 를 참고하세요.
[품사태그표]
https://docs.google.com/spreadsheets/d/1-9blXKjtjeKZqsf4NzHeYJCrr49-nXeRF6D80udfcwY/edit#gid=4

대분류	세종 품사 태그		mecab-ko-dic 품사 태그	
	태그	설명	        태그	설명
체언	NNG	일반 명사	NNG	일반 명사
	NNP	고유 명사	NNP	고유 명사
	NNB	의존 명사	NNB	의존 명사
			        NNBC	단위를 나타내는 명사
	NR	수사    	NR	수사
	NP	대명사  	NP	대명사
용언	VV	동사    	VV	동사
	VA	형용사  	VA	형용사
	VX	보조 용언	VX	보조 용언
	VCP	긍정 지정사	VCP	긍정 지정사
	VCN	부정 지정사	VCN	부정 지정사
관형사	MM	관형사   	MM	관형사
부사	MAG	일반 부사	MAG	일반 부사
	MAJ	접속 부사	MAJ	접속 부사
------------------------------------------------


사전 컴파일
------------------------------------------
$ mecab-ko-dic/tools/add-userdic.sh
아래와 같이 user-xxx.csv 사전이 추가된 모습을 볼 수 있습니다. 사실 아래 파일은 컴파일 되기 직전의 파일이며, 실제로 sys.dic 파일에 바이너리로 컴파일 되어 들어가게 됩니다.
mecab-ko-dic
├── ....
├── user-nnp.csv
├── user-person.csv
├── user-place.csv
└── ...

설치
---------------------------
$ make install
