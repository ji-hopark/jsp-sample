// accountDetail.jsp 전용: 계좌번호 클립보드 복사.
const copyButton = document.getElementById('copy-account');
if (copyButton) {
    copyButton.addEventListener('click', async () => {
        const status = document.getElementById('copy-status');
        try {
            await navigator.clipboard.writeText(copyButton.dataset.number);
            status.textContent = '계좌번호를 복사했습니다.';
        } catch (error) {
            status.textContent = '복사할 수 없습니다. 위 계좌번호를 선택해 복사해 주세요.';
        }
    });
}
