<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page import="kopo.poly.dto.NewsDTO" %>

<%
    NewsDTO rDTO = (NewsDTO) request.getAttribute("rDTO"); // Controller가 넘겨준 뉴스 DTO

    // JS 문자열 안에 그대로 넣으면 따옴표/줄바꿈 때문에 문법이 깨지므로 미리 치환
    String newsName = CmmUtil.nvl(rDTO.getNewsName()).replaceAll("\n", " ").replaceAll("\"", " ");
    String newsContent = CmmUtil.nvl(rDTO.getNewsContent()).replaceAll("\n", " ").replaceAll("\"", " ");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>네이버 뉴스 수집 결과</title>
    <link rel="stylesheet" href="/css/news.css"/>
    <script type="text/javascript" src="/js/jquery-3.7.1.min.js"></script>
    <script>

        // Java 변수의 값을 JS 변수로 옮겨 담음
        const newsName = "<%=newsName%>";
        const newsContent = "<%=newsContent%>";

        // HTML 로딩이 완료되고, 실행됨
        $(document).ready(function () {
            // 버튼 클릭했을 때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
            $("#btnTextRead").on("click", function () {
                speak(newsName + '\n' + newsContent); // 기사를 speak 함수에 넘김
            })
        })

        // 문자열 읽기 함수
        function speak(text) {
            if (typeof SpeechSynthesisUtterance === "undefined" ||
                typeof window.speechSynthesis === "undefined") {
                // 브라우저가 음성 합성 기능을 지원하는지 확인

                alert("이 브라우저는 문자읽기 기능을 지원하지 않습니다.");
                return;
            }

            window.speechSynthesis.cancel() // 이미 읽고 있다면 취소 (중복 재생 방지)

            const  speechMsg = new SpeechSynthesisUtterance() // 음성으로 읽을 내용을 담을 객체 생성
            speechMsg.rate = 1; // 속도: 0.1 ~ 10
            speechMsg.pitch = 1; // 음높이: 0 ~ 2
            speechMsg.lang = "ko-KR"; // 읽을 언어는 한국어 설정
            speechMsg.text = text; // 실제로 읽을 텍스트 내용 지정

            // 문자 읽기
            window.speechSynthesis.speak(speechMsg);
        }
    </script>
</head>
<body>
<div>
    <button id="btnTextRead" type="button">읽어주기</button>
</div>
<div class="newsCard">
    <div class="newsName"><%=newsName%></div>
    <div class="newsContent"><%=CmmUtil.nvl(rDTO.getNewsContent())%></div>
</div>

</body>
</html>