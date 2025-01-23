# whale-music

### Spotyfy API를 활용한 음악 스트리밍 서비스와 커뮤니티 및 SNS 기능을 결합하여, 사용자 간의 소통과 참여를 강화한 웹 개발 프로젝트
<br>


개발 기간 : 2024.10.15 ~ 2024.11.21

개발 인원 : 5명

담당 업무 : DB Manager, Feed & Community & Message & Profile 총괄

프레임워크 : Spring, Spring Boot, MyBatis

데이터베이스 : Oracle 11g XE

<br>

### <담당 세부기능>

1. DB

![image](https://github.com/user-attachments/assets/976e7dc3-4fc0-48d9-a500-23c8569336f0)

<br>

##### 1) DB 테이블 Pr & Fr & Sequence 구성
##### 2) 각 기능간 유동적인 데이터 처리를 위해 join & subquery 활용 가능한 테이블 구현

<br>
<br>

2. Feed

   ![image](https://github.com/user-attachments/assets/5b2cc94f-b653-4ab0-95fb-fed2c67afb78)
   ![image](https://github.com/user-attachments/assets/99d41aab-bf49-4b78-9eb1-83cdba1b2d0b)
   ![image](https://github.com/user-attachments/assets/d34aba1e-8f87-4b1c-a2eb-dad4c516375b)
   ![image](https://github.com/user-attachments/assets/2658569d-e275-4bd4-a0df-ccc59177df0a)

<br>

##### 1) 인스타그램 디자인을 차용한 피드 기능 구현
##### 2) 모달창을 통한 게시글 숨기기, 게시글 삭제, 게시글 신고 기능 구현
##### 3) Spotyfy API를 활용해 음악 삽입 및 재생 기능 구현
##### 4) Ajax 비동기 갱신 기능을 통해 좋아요 및 댓글 실시간 처리 기능 구현

<br>
<br>

3. Community

   ![image](https://github.com/user-attachments/assets/db5d0715-fd90-4486-863c-e9d80fc51256)
   ![image](https://github.com/user-attachments/assets/b60e0f81-ed8d-47d2-971f-27d258dea740)
   ![image](https://github.com/user-attachments/assets/e4eac186-6602-4323-96b6-a757d1c543a3)
   ![image](https://github.com/user-attachments/assets/a4c7196e-19a2-45df-8db2-daca01bcb847)
   
<br>

##### 1) 각 커뮤니티에 대한 즐겨찾기 기능 구현
##### 2) 관리자 공지사항 및 유저 기본 CRUD 기능 구현
##### 3) DB tag 테이블 및 제목, 내용 등 join & subquery 활용한 검색 기능 구현
##### 4) Ckeditor 라이브러리 활용
##### 5) 링크 공유 기능 & 메시지 연동

<br>
<br>

4. Message

   ![image](https://github.com/user-attachments/assets/d6af37a6-b77c-4a0b-8865-52de75dadc3e)
   ![image](https://github.com/user-attachments/assets/bba568ef-a93c-4b97-8471-bb4d17ae0cfb)
   ![image](https://github.com/user-attachments/assets/b8c26058-c631-4843-8c80-2f63ac3a2e3b)
   
<br>

##### 1) WebSocket 활용으로 실시간 통신 기능 구현
##### 2) 텍스트, 이미지, 이모티콘, 음악, 링크 등 타입별 메시지 기능 구현
##### 3) 메시지 삭제 및 나가기 기능 구현(본인과 타인간 메시지 구별)
##### 4) HomeChatHandler 추가 구성으로 메인 화면에서 실시간으로 메시지 확인 가능

<br>
<br>

5. Profile

	 ![image](https://github.com/user-attachments/assets/13d8186c-8f4d-4ac8-b805-6bde1d94ca95)
	 ![image](https://github.com/user-attachments/assets/492cdbf7-e10d-4041-b879-7ba13adb6da5)
	 ![image](https://github.com/user-attachments/assets/60f977c8-fc1c-47de-b7b0-742e19edc776)
   
<br>

##### 1) 인스타그램과 유사한 비공개 & 공개 프로필 및 팔로잉 로직 구현
##### 2) 팔로우 여부, 비공개 여부에 따라 달라지는, jstl 활용한 경우의 수 처리
##### 3) 뮤직 프로필, 피드 탭 및 음악 탭 미리보기 기능 구현






