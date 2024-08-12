# ToneGenerator
### 헤드셋을 이용한 청력검사와 진단 서비스
![최종발표-009](https://github.com/user-attachments/assets/a195a781-3490-44f5-9f69-89dc7ecd48c1)

## 프로젝트 개요

이 프로젝트는 헤드셋을 이용해 순음청력검사를 실시하여 난청의 유형을 진단해주는 모바일 애플리케이션 서비스입니다. 
IT 공학과 HCI(Human-Computer Interface) 수업(2022-2) 프로젝트의 일환으로 개발되었습니다.


## 주요 기능
![009](https://github.com/user-attachments/assets/2c74455f-61b5-4808-b04a-5eefd04e98d8)
![010](https://github.com/user-attachments/assets/cbfa9737-eab9-48cc-9629-87e504061a3b)

1. 순음청력검사 실시
2. 오디오그램 출력
3. 난청 유형 진단

## 기술 스택

- 프로그래밍 언어: Swift
- 오디오 처리: AVPlayerAudioNode
- 그래픽: Swift 내장 그래프 라이브러리

## 구현 과정

### 1. 주파수별 소리 준비
![005 (1)](https://github.com/user-attachments/assets/c28609c9-45c6-406e-8094-871f941d6a42)

- 어도비 어디션 대신 Apple의 AVPlayerAudioNode 라이브러리 사용
- 125~8kHz 범위의 주파수에서 0dB～100dB 음압레벨의 순음 생성

### 2. 순음청력검사 기능 구현
![006](https://github.com/user-attachments/assets/709d12ce-6deb-423a-8004-eca2b5f5ae66)

- Timer를 사용하여 주파수 소리 간 3초의 간격 설정
- 사용자 응답 처리 및 데이터 수집

### 3. 오디오그램 출력
![007](https://github.com/user-attachments/assets/e3e642ee-f086-440f-a589-967cec568847)

- 수집된 데이터를 바탕으로 주파수(x축)와 데시벨(y축)의 선그래프 생성

### 4. 난청 유형 진단

다음과 같은 기준으로 난청 유형을 진단:

1. 수평형(Flat): 모든 주파수에서 청력 손실 정도가 20dB 이내
2. 경사형: 옥타브 간 6-10dB 차이
3. Sharply sloping: 옥타브 간 11-15dB 차이
4. Precipitously sloping: 옥타브 간 16dB 이상 차이
5. 상승형: 고주파수로 갈수록 청력이 좋아지는 형태
6. 접시형: 중주파수 영역(1,000~2,000Hz)에서 20dB 이상 청력 저하
7. 톱니형: 특정 주파수에서 20dB 이상 청력이 급격히 나빠졌다가 회복되는 형태

## 프로젝트 의의

- HCI 개념을 실제 서비스 개발에 적용
- 기존 청력 검사 앱들의 한계점 개선 (결과 해석의 용이성)
- 사용자 데이터 직접 수집 및 분석 경험

## 기술적 도전과 해결

1. **주파수 소리 생성**: 
   - 문제: 80개의 개별 오디오 파일 생성의 비효율성
   - 해결: AVPlayerAudioNode 라이브러리를 사용하여 코드로 동적 생성

2. **사용자 친화적 결과 제시**: 
   - 문제: 기존 앱들의 전문적이고 이해하기 어려운 결과 표시
   - 해결: 일반인도 이해하기 쉬운 난청 유형 진단 결과 제공

## 학습 내용

1. Swift를 이용한 iOS 앱 개발
2. AVPlayerAudioNode를 활용한 오디오 처리
3. Timer를 이용한 정교한 사용자 경험 설계
4. 데이터 시각화 (오디오그램 생성)
