import { element, badge, link, tableMessage, setupSearch } from './common.js';

// customerList.jsp 전용: 고객 AJAX 검색과 상세 화면 연결.
const body = document.getElementById('customer-rows');
const count = document.getElementById('customer-count');
setupSearch({
    form: document.getElementById('customer-form'), endpoint: 'customerListAction.jsp',
    container: body, count,
    render(data) {
        body.replaceChildren();
        for (const customer of data.customers) {
            const row = element('tr');
            const name = element('td', customer.name);
            name.append(element('div', customer.id, 'secondary mono'));
            const tier = element('td'); tier.append(badge(customer.tier));
            const state = element('td'); state.append(badge(customer.state));
            const detail = element('td');
            const detailLink = link('상세 보기 →', 'customerDetail.jsp?id=' + encodeURIComponent(customer.id));
            detailLink.setAttribute('aria-label', customer.name + ' 고객 상세 보기');
            detail.append(detailLink);
            row.append(name, tier, element('td', customer.phone, 'mono'), element('td', customer.manager), state, detail);
            body.append(row);
        }
        if (!data.customers.length) tableMessage(body, '조회 조건에 맞는 고객이 없습니다.', 6);
        count.textContent = '총 ' + data.customers.length + '명의 고객';
    },
    error: message => tableMessage(body, message, 6)
});
