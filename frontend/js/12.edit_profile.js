window.onload = function() {
    // 1. 기존 데이터 불러오기
    const currentName = localStorage.getItem('userName');
    const currentEmail = localStorage.getItem('userEmail') || ''; // 저장된 게 없다면 빈칸
    const currentPhone = localStorage.getItem('userPhone') || '';

    // 2. 입력란에 미리 채워넣기
    document.getElementById('editName').value = currentName;
    document.getElementById('editEmail').value = currentEmail;
    document.getElementById('editPhone').value = currentPhone;
};

// 3. 수정 완료 처리
document.getElementById('editForm').onsubmit = function(e) {
    e.preventDefault(); // 페이지 새로고침 방지

    const newName = document.getElementById('editName').value;
    const newEmail = document.getElementById('editEmail').value;
    const newPhone = document.getElementById('editPhone').value;

    if (confirm("정보를 수정하시겠습니까?")) {
        // 데이터 업데이트
        localStorage.setItem('userName', newName);
        localStorage.setItem('userEmail', newEmail);
        localStorage.setItem('userPhone', newPhone);

        alert("회원 정보가 성공적으로 수정되었습니다.");
        location.href = '11.mypage.html'; // 마이페이지로 이동
    }
};
