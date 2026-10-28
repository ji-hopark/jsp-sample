// 화면별 JS에서 가져다 쓰는 DOM, 조회, CSV 공통 함수입니다.
export function element(tag, text = '', className = '') {
    const node = document.createElement(tag);
    node.textContent = text;
    node.className = className;
    return node;
}

export function badge(text) {
    const color = ['정상', '완료', '우수', '프리미엄'].includes(text) ? 'good'
        : ['확인필요', '예약', '중요'].includes(text) ? 'warn'
        : text === '실패' ? 'danger' : 'neutral';
    return element('span', text, 'badge ' + color);
}

export function link(text, href) {
    const node = element('a', text, 'text-link');
    node.href = href;
    return node;
}

export function tableMessage(body, text, columns) {
    const row = element('tr');
    const cell = element('td', text, 'empty');
    cell.colSpan = columns;
    row.append(cell);
    body.replaceChildren(row);
}

export function setupSearch({ form, endpoint, container, count, render, error }) {
    let controller;
    async function load() {
        if (controller) controller.abort();
        const current = new AbortController();
        controller = current;
        container.setAttribute('aria-busy', 'true');
        count.textContent = '조회 중';
        try {
            const response = await fetch(endpoint + '?' + new URLSearchParams(new FormData(form)), {
                signal: current.signal, headers: { Accept: 'application/json' }
            });
            if (!response.ok) throw new Error('조회 실패');
            const data = await response.json();
            if (controller === current) render(data);
        } catch (exception) {
            if (exception.name !== 'AbortError' && controller === current) {
                count.textContent = '조회 실패';
                error('데이터를 불러오지 못했습니다. 조회 버튼을 눌러 다시 시도해 주세요.');
            }
        } finally {
            if (controller === current) container.setAttribute('aria-busy', 'false');
        }
    }
    form.addEventListener('submit', event => { event.preventDefault(); load(); });
    form.addEventListener('reset', event => {
        event.preventDefault();
        for (const control of form.elements) {
            if (control.tagName === 'SELECT') control.selectedIndex = 0;
            else if (control.tagName === 'INPUT') control.value = '';
        }
        load();
    });
    load();
}

export function downloadCsv(filename, rows) {
    const csv = rows.map(row => row.map(value => {
        let text = String(value);
        if (/^[=+\-@\t\r]/.test(text)) text = "'" + text;
        return '"' + text.replaceAll('"', '""') + '"';
    }).join(',')).join('\r\n');
    const url = URL.createObjectURL(new Blob(['\uFEFF', csv], { type: 'text/csv;charset=utf-8' }));
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = filename;
    document.body.append(anchor);
    anchor.click();
    anchor.remove();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
}
