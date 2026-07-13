<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%
    // 채팅방 명
    String roomName = CmmUtil.nvl(request.getParameter("roomName"));

    // 채팅방 입장 전 입력한 별명
    String userName = CmmUtil.nvl(request.getParameter("userName"));

%>
<html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%=roomName%> 채팅방 입장 </title>
    <link rel="stylesheet" href="/css/table.css"/>
    <script type="text/javascript" src="/js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">

        let data = {}; // 전송 데이터(JSON)
        let ws; // 웹소켓 객체
        const roomName = "<%=roomName%>"; // 채팅방 이름
        const userName = "<%=userName%>"; // 채팅 유저 이름

        $(document).ready(function () {

            // 웹소켓 객체를 생성하는 중
            if (ws !== undefined && ws.readyState !== WebSocket.CLOSED) {
                console.log("WebSocket is already opened.");
                return;

            }

            // 접속 URL 예 : ws://localhost:11000/ws/테스트방/별명
            ws = new WebSocket("ws://" + location.host + "/ws/" + roomName + "/" + userName);

            // 웹소켓 열기
            ws.onopen = function (event) {
                if (event.data === undefined)
                    return;

                console.log(event.data)
            };

            // 웹소켓으로부터 메시지를 받을 때마다 실행됨
            ws.onmessage = function (msg) {

                // 웹소켓으부터 받은 데이터를 JSON 구조로 변환하기
                let data = JSON.parse(msg.data);

                if (data.name === userName) { // 내가 발송한 채팅 메시지는 파란색 글씨
                    $("#chat").append("<div>");
                    $("#chat").append("<span style='color: blue'><b>[보낸 사람] : </b></span>");
                    $("#chat").append("<span style='color: blue'><b> 나 </b></span>");
                    $("#chat").append("<span style='color: blue'><b>[발송 메시지] : </b></span>");
                    $("#chat").append("<span style='color: blue'>" + data.msg + "</span>");
                    $("#chat").append("<span style='color: blue'><b>[발송 시간] : </b></span>");
                    $("#chat").append("<span style='color: blue'>" + data.date + "</span>");
                    $("#chat").append("</div>");

                } else if (data.name === "관리자") { // 관리자가 발송한 채팅 메시지는 빨간색 글씨
                    $("#chat").append("<div>");
                    $("#chat").append("<span style='color: red'><b>[보낸 사람] : </b></span>");
                    $("#chat").append("<span style='color: red'>" + data.name + "</span>");
                    $("#chat").append("<span style='color: red'><b>[발송 메시지] : </b></span>");
                    $("#chat").append("<span style='color: red'>" + data.msg + "</span>");
                    $("#chat").append("<span style='color: red'><b>[발송 시간] : </b></span>");
                    $("#chat").append("<span style='color: red'>" + data.date + "</span>");
                    $("#chat").append("</div>");
                } else {
                    $("#chat").append("<div>"); // 그 외 채팅 참여자들이 발송한 채팅 메시지는 검정색
                    $("#chat").append("<span style='color: black'><b>[보낸 사람] : </b></span>");
                    $("#chat").append("<span style='color: black'>" + data.name + "</span>");
                    $("#chat").append("<span style='color: black'><b>[수신 메시지] : </b></span>");
                    $("#chat").append("<span style='color: black'>" + data.msg + "</span>");
                    $("#chat").append("<span style='color: black'><b>[발송 시간] : </b></span>");
                    $("#chat").append("<span style='color: black'>" + data.date + "</span>");
                    $("#chat").append("</div>");

                }
            }
             $("#btnSend").on("click", function() {
                 data.name = userName; // 별명
                 data.msg = $("#msg").val(); // 입력한 메시지

                 let chatMsg = JSON.stringify(data); // 데이터 구조를 JSON 형태로 변경하기

                 ws.send(chatMsg); // 채팅 메시지 전송하기

                 $("#msg").val(""); // 채팅 메시지 전송 후, 입력한 채팅내용 지우기
             })
        });
    </script>
</head>
<body>
<h1><%=userName%>님! <%=roomName%> 입장을 환영합니다.</h1>
<hr/>
<br/><br/>
<div class="divTable minimalistBlack">
    <div class="divTableHeading">
        <div class="divTableRow">
            <div class="divTableHead">대화 내용</div>
        </div>
    </div>
    <div class="divTableBody">
        <div class="divTableRow">
            <div class="divTableCell" id="chat"></div>
        </div>
    </div>
</div>
<br/><br/>
<div class="divTable minimalistBlack">
    <div class="divTableBody">
        <div class="divTableRblack
            <div class="divTableCell">전달할 메시지</div>
            <div class="divTableCell">
                <input type="text" id="msg">
                <button id="btnSend">메시지 전송</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
</html>