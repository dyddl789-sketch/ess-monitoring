<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div style="padding:20px; border:1px solid #ddd;">
    <h2>🔧 ESS 기기 등록</h2>

    <form id="deviceForm">
        <table>
            <tr>
                <td>기기 이름</td>
                <td><input type="text" name="device_name"></td>
            </tr>
            <tr>
                <td>위치</td>
                <td><input type="text" name="location"></td>
            </tr>
            <tr>
                <td>용량</td>
                <td><input type="text" name="capacity"></td>
            </tr>
        </table>

        <button type="button" id="btnRegister">등록</button>
        <button type="button" id="btnBack">뒤로</button>
    </form>
</div>