import { element, badge, link, setupSearch } from './common.js';

// notificationList.jsp 전용: AJAX 조회, 탭 단위 읽음 상태, 관련 화면 연결.
const items = document.getElementById('notification-items');
const count = document.getElementById('notification-count');
const readAll = document.getElementById('read-all');
const readState = document.getElementById('read-state');
const storageKey = 'nova-sample-read-notices';
let readIds = new Set();
try {
    const saved = JSON.parse(sessionStorage.getItem(storageKey) || '[]');
    if (Array.isArray(saved)) readIds = new Set(saved.filter(value => typeof value === 'string'));
} catch (error) { /* 저장소가 제한된 경우 현재 화면에서만 상태를 유지합니다. */ }
let notices = [];
function save() {
    try { sessionStorage.setItem(storageKey, JSON.stringify([...readIds])); } catch (error) { /* 현재 화면에서는 계속 사용 가능 */ }
}
function render() {
    const visible = notices.filter(notice => !readState.value || (readState.value === 'read') === readIds.has(notice.id));
    document.getElementById('notice-total').textContent = notices.length;
    document.getElementById('notice-unread').textContent = notices.filter(notice => !readIds.has(notice.id)).length;
    document.getElementById('notice-important').textContent = notices.filter(notice => notice.category === '중요').length;
    readAll.disabled = !notices.some(notice => !readIds.has(notice.id));
    items.replaceChildren();
    for (const notice of visible) {
        const isRead = readIds.has(notice.id);
        const card = element('article', '', 'notification-card' + (isRead ? ' is-read' : ''));
        const content = element('div', '', 'notification-content');
        const meta = element('div', '', 'notification-meta');
        meta.append(badge(notice.category), element('span', notice.date, 'secondary mono'), element('span', isRead ? '읽음' : '읽지 않음', 'read-label'));
        content.append(meta, element('h2', notice.title), element('p', notice.body, 'notification-body'));
        if (notice.href) content.append(link(notice.linkText + ' ↗', notice.href));
        const button = element('button', isRead ? '읽지 않음으로' : '읽음으로 표시', 'button');
        button.type = 'button';
        button.setAttribute('aria-label', notice.title + ' ' + button.textContent);
        button.addEventListener('click', () => {
            if (readIds.has(notice.id)) readIds.delete(notice.id); else readIds.add(notice.id);
            save(); render();
        });
        card.append(content, button);
        items.append(card);
    }
    if (!visible.length) items.append(element('p', '조회 조건에 맞는 알림이 없습니다.', 'empty'));
    count.textContent = '총 ' + visible.length + '건의 알림';
}
readState.addEventListener('change', render);
readAll.addEventListener('click', () => { notices.forEach(notice => readIds.add(notice.id)); save(); render(); });
setupSearch({
    form: document.getElementById('notification-form'), endpoint: 'notificationListAction.jsp',
    container: items, count,
    render(data) { notices = data.notices; render(); },
    error(message) {
        notices = [];
        items.replaceChildren(element('p', message, 'empty'));
        readAll.disabled = true;
        for (const id of ['notice-total', 'notice-unread', 'notice-important']) document.getElementById(id).textContent = '—';
    }
});
