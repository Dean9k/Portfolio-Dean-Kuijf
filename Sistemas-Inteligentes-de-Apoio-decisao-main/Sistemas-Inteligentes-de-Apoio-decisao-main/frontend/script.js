'use strict';

document.addEventListener('DOMContentLoaded', () => {

    // DEFINIR FAVICON E TÍTULO NA ABA DO NAVEGADOR
    const favicon = document.createElement('link');
    favicon.rel = 'icon';
    favicon.href = '/Logo-SNS.png';
    document.head.appendChild(favicon);
    document.title = 'Triagem SNS24';

    // REFERÊNCIAS DOM
    const idSection           = document.getElementById('identification-section');
    const nifForm             = document.getElementById('nif-form');
    const nifInput            = document.getElementById('nif');
    const nifSubmitBtn        = document.getElementById('nif-submit');
    const registrationForm    = document.getElementById('registration-form');
    const nomeInput           = document.getElementById('nome');
    const dataNascimentoInput = document.getElementById('data_nascimento');
    const registerSubmitBtn   = document.getElementById('register-submit');
    const backToNifBtn        = document.getElementById('back-to-nif-btn');
    const userWelcome         = document.getElementById('user-welcome');
    const welcomeAvatar       = document.getElementById('welcome-avatar');
    const welcomeNifDisplay   = document.getElementById('welcome-nif-display');
    const idError             = document.getElementById('id-error');
    const welcomeContainer    = document.getElementById('welcome-container');
    const proceedTriageBtn    = document.getElementById('proceed-triage-btn');
    const themeToggleBtn      = document.getElementById('theme-toggle-btn');
    const iconMoon            = document.getElementById('icon-moon');
    const iconSun             = document.getElementById('icon-sun');
    const sessionTimerEl      = document.getElementById('session-timer');

    const fluxoSection        = document.getElementById('fluxo-section');
    const fluxoGrid           = document.getElementById('fluxo-grid');
    const triageSection       = document.getElementById('triage-section');
    const questionContainer   = document.getElementById('question-container');
    const questionCounter     = document.getElementById('question-counter');
    const triageError         = document.getElementById('triage-error');

    const resultSection       = document.getElementById('result-section');
    const resultContent       = document.getElementById('result-content');

    const restartButton       = document.getElementById('restart-button');
    const printResultBtn      = document.getElementById('print-result-btn');
    const copyResultBtn       = document.getElementById('copy-result-btn');

    const historySection      = document.getElementById('history-section');
    const historyContent      = document.getElementById('history-content');
    const historyBtn          = document.getElementById('history-btn');
    const closeHistoryBtn     = document.getElementById('close-history-btn');



    const connector1 = document.getElementById('connector-1');
    const connector2 = document.getElementById('connector-2');
    const toastEl    = document.getElementById('toast');

    // ESTADO GLOBAL
    let triageState  = { nif: null, answers: {}, fluxo: null };
    let currentUser  = null; // { nif, nome, idade } — preenchido no login
    let questionCount = 0;
    let sessionStartTime = null;
    let sessionTimerInterval = null;
    let lastResult = null; // guarda o último resultado para a funcionalidade copiar

    // FLUXOS DE TRIAGEM
    const FLUXOS = [
        {
            id: 'respiratorio',
            label: 'Sistema Respiratório',
            desc: 'Falta de ar, tosse, pieira, dificuldade a respirar',
            svgPath: '<path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>'
        },
        {
            id: 'febre_geral',
            label: 'Febre / Gastrointestinal',
            desc: 'Febre, vómitos, diarreia, dor abdominal, garganta',
            svgPath: '<path d="M13 2.05V4.07c3.94.49 7 3.85 7 7.93 0 3.21-1.82 6-4.72 7.28L13 17v5h5l-1.22-1.22C19.91 19.07 22 15.76 22 12c0-5.18-3.95-9.45-9-9.95zM11 2.05C5.95 2.55 2 6.82 2 12c0 3.76 2.09 7.07 5.22 8.78L6 22h5v-5l-2.28 2.28C7.82 18 6 15.21 6 12c0-4.08 3.06-7.44 7-7.93V2.05z"/>'
        },
        {
            id: 'outros',
            label: 'Outros Sintomas',
            desc: 'Dor no peito, cabeça, neurológico, urinário, olhos, pele',
            svgPath: '<circle cx="12" cy="12" r="3"/><path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/>'
        },
    ];

    // TIMER DE SESSÃO
    function startSessionTimer() {
        sessionStartTime = Date.now();
        sessionTimerEl.classList.remove('hidden');
        clearInterval(sessionTimerInterval);
        sessionTimerInterval = setInterval(() => {
            const elapsed = Math.floor((Date.now() - sessionStartTime) / 1000);
            const min = String(Math.floor(elapsed / 60)).padStart(2, '0');
            const sec = String(elapsed % 60).padStart(2, '0');
            sessionTimerEl.textContent = `${min}:${sec}`;
        }, 1000);
    }

    function stopSessionTimer() {
        clearInterval(sessionTimerInterval);
        sessionTimerEl.classList.add('hidden');
        sessionTimerEl.textContent = '';
        sessionStartTime = null;
    }

    // TOAST DE FEEDBACK
    let toastTimeout = null;
    function showToast(msg, type = 'info') {
        clearTimeout(toastTimeout);
        toastEl.textContent = msg;
        toastEl.className = `toast toast-${type}`;
        toastEl.classList.remove('hidden');
        toastTimeout = setTimeout(() => {
            toastEl.classList.add('hidden');
        }, 3000);
    }

    // HELPERS DE COMUNICAÇÃO
    async function apiCall(endpoint, body) {
        try {
            const res = await fetch(endpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            return await res.json();
        } catch (err) {
            console.error(`[apiCall] ${endpoint}:`, err);
            return { error: 'Não foi possível comunicar com o servidor. Verifique a ligação.' };
        }
    }

    // INDICADOR DE PROGRESSO
    function updateProgress(stepId) {
        const steps = ['step-utente', 'step-sintomas', 'step-resultado'];
        const idx   = steps.indexOf(stepId);

        steps.forEach((id, i) => {
            const el = document.getElementById(id);
            el.classList.remove('active', 'completed');
            if      (i < idx)   el.classList.add('completed');
            else if (i === idx) el.classList.add('active');
        });

        if (connector1) {
            connector1.classList.toggle('completed', idx > 1);
            connector1.classList.toggle('active',    idx === 1);
        }
        if (connector2) {
            connector2.classList.toggle('completed', idx > 2);
            connector2.classList.toggle('active',    idx === 2);
        }
    }

    updateProgress('step-utente');

    // VALIDAÇÃO DO NIF (SIMPLIFICADA PARA TESTES)
    function isValidNIF(nif) {
        // Aceita qualquer número que tenha exatamente 9 dígitos
        return /^\d{9}$/.test(nif);
    }

    // IDENTIFICAÇÃO DO UTENTE

    // Validação e restrição em tempo real do NIF
    nifInput.addEventListener('input', (e) => {
        // Remove tudo o que não for dígito
        let val = nifInput.value.replace(/\D/g, '');
        
        // Garante que não ultrapassa os 9 dígitos (redundância de segurança)
        if (val.length > 9) {
            val = val.slice(0, 9);
        }
        
        // Atualiza o valor do input apenas com números e máximo de 9
        nifInput.value = val;

        if (val.length === 9) {
            if (!isValidNIF(val)) {
                nifInput.classList.add('input-invalid');
                nifInput.setAttribute('aria-invalid', 'true');
            } else {
                nifInput.classList.remove('input-invalid');
                nifInput.classList.add('input-valid');
                nifInput.removeAttribute('aria-invalid');
            }
        } else {
            nifInput.classList.remove('input-invalid', 'input-valid');
            nifInput.removeAttribute('aria-invalid');
        }
        clearError(idError);
    });

    nifInput.addEventListener('keydown', e => {
        if (e.key === 'Enter') nifSubmitBtn.click();
    });

    nifSubmitBtn.addEventListener('click', async () => {
        const nif = nifInput.value.trim();

        if (!/^\d{9}$/.test(nif)) {
            showError(idError, 'Introduza exatamente 9 dígitos numéricos.');
            nifInput.focus();
            return;
        }

        clearError(idError);
        triageState.nif = nif;

        nifSubmitBtn.disabled = true;
        nifSubmitBtn.innerHTML = '<span class="btn-spinner"></span> A verificar...';

        const response = await apiCall('/api/user', { action: 'check', nif });

        nifSubmitBtn.disabled = false;
        nifSubmitBtn.innerHTML = 'Continuar <span class="btn-arrow" aria-hidden="true">→</span>';

        if (response.error)      { showError(idError, response.error); }
        else if (response.found) { showWelcome(response.user.nome, response.user.idade); }
        else                     { showRegistrationForm(); }
    });

    backToNifBtn.addEventListener('click', () => {
        registrationForm.classList.add('hidden');
        nifForm.classList.remove('hidden');
        clearError(idError);
        nifInput.focus();
    });

    registerSubmitBtn.addEventListener('click', async () => {
        const nome           = nomeInput.value.trim();
        const dataNascimento = dataNascimentoInput.value;

        if (!nome || nome.length < 2) {
            showError(idError, 'Por favor, introduza o nome completo (mínimo 2 caracteres).');
            nomeInput.focus();
            return;
        }
        if (!dataNascimento) {
            showError(idError, 'Por favor, selecione a data de nascimento.');
            dataNascimentoInput.focus();
            return;
        }
        const birthDate = new Date(dataNascimento);
        const today     = new Date();
        if (birthDate > today) {
            showError(idError, 'A data de nascimento não pode ser no futuro.');
            dataNascimentoInput.focus();
            return;
        }
        const age = calcularIdadeJS(dataNascimento);
        if (age > 130) {
            showError(idError, 'Data de nascimento inválida.');
            dataNascimentoInput.focus();
            return;
        }

        clearError(idError);
        registerSubmitBtn.disabled = true;
        registerSubmitBtn.innerHTML = '<span class="btn-spinner"></span> A registar...';

        const response = await apiCall('/api/user', {
            action: 'register', nif: triageState.nif, nome, data_nascimento: dataNascimento
        });

        registerSubmitBtn.disabled = false;
        registerSubmitBtn.innerHTML = 'Registar e Iniciar →';

        if (response.error)     { showError(idError, response.error); }
        else if (response.success) { showWelcome(nome, calcularIdadeJS(dataNascimento)); }
    });

    function showRegistrationForm() {
        nifForm.classList.add('hidden');
        registrationForm.classList.remove('hidden');
        nomeInput.focus();
    }

    function showWelcome(nome, idade) {
        nifForm.classList.add('hidden');
        registrationForm.classList.add('hidden');
        const initials = nome.split(' ').filter(Boolean).map(w => w[0]).slice(0, 2).join('').toUpperCase();
        welcomeAvatar.textContent = initials || '?';
        welcomeAvatar.setAttribute('aria-label', `Iniciais: ${initials}`);
        userWelcome.innerHTML = `Bem-vindo(a), <strong>${escapeHtml(nome)}</strong> (${idade} anos).`;
        welcomeNifDisplay.textContent = `NIF: ${triageState.nif}`;
        welcomeContainer.classList.remove('hidden');
        proceedTriageBtn.focus();
        // Guarda o utilizador para o chatbot usar como contexto
        currentUser = { nif: triageState.nif, nome, idade };
    }

    function calcularIdadeJS(dataNasc) {
        const birth = new Date(dataNasc);
        const today = new Date();
        let age = today.getFullYear() - birth.getFullYear();
        const m = today.getMonth() - birth.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age--;
        return age;
    }

    // TRIAGEM — SELEÇÃO DE FLUXO
    proceedTriageBtn.addEventListener('click', showFluxoSelection);

    function showFluxoSelection() {
        idSection.classList.add('hidden');
        fluxoSection.classList.remove('hidden');
        updateProgress('step-sintomas');
        questionCount = 0;

        fluxoGrid.innerHTML = '';
        FLUXOS.forEach(f => {
            const btn = document.createElement('button');
            btn.className = 'fluxo-btn';
            btn.setAttribute('type', 'button');
            btn.innerHTML = `
                <div class="fluxo-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">${f.svgPath}</svg>
                </div>
                <span class="fluxo-label">${f.label}</span>
                <span class="fluxo-desc">${f.desc}</span>
            `;
            btn.setAttribute('aria-label', `${f.label}: ${f.desc}`);
            btn.addEventListener('click', () => {
                triageState.fluxo = f.id;
                startTriage();
            });
            fluxoGrid.appendChild(btn);
        });
    }

    // TRIAGEM — PERGUNTAS
    async function startTriage() {
        triageState.answers = {};
        questionCount = 0;
        lastResult = null;

        fluxoSection.classList.add('hidden');
        triageSection.classList.remove('hidden');
        updateProgress('step-sintomas');

        startSessionTimer();
        await getTriageStep();
    }

    async function getTriageStep() {
        const response = await apiCall('/api/triage', triageState);

        if (response.error) {
            showError(triageError, response.error);
        } else if (response.type === 'question') {
            clearError(triageError);
            questionContainer.classList.remove('hidden');
            renderQuestion(response.question);
        } else if (response.type === 'result') {
            stopSessionTimer();
            renderResult(response.result);
        }
    }

    function renderQuestion(question) {
        questionCount++;
        updateQuestionCounter();

        questionContainer.innerHTML = '';
        const block = document.createElement('div');
        block.className = 'question-block';

        let html = `
            <div class="question-header">
                <p id="question-text">${escapeHtml(question.text)}</p>
                <button class="tooltip-btn" type="button" aria-label="Porquê esta pergunta?" aria-expanded="false" aria-controls="tooltip-content-${questionCount}">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                </button>
            </div>
            <div class="tooltip-content hidden" id="tooltip-content-${questionCount}" role="tooltip">
                <strong>Porquê esta pergunta?</strong><br>${escapeHtml(question.reason)}
            </div>
            <div class="question-buttons" role="group" aria-labelledby="question-text">
        `;

        if (question.q_type === 'sn') {
            html += `
                <button class="btn-yes" type="button" data-answer="s" aria-label="Sim">Sim</button>
                <button class="btn-no"  type="button" data-answer="n" aria-label="Não">Não</button>
            `;
        } else if (question.q_type === 'scale') {
            html += `
                <div class="scale-wrapper">
                    <div class="scale-labels">
                        <span>0 — Sem dor / Nenhum</span>
                        <span>10 — Máxima intensidade</span>
                    </div>
                    <input type="range" id="scale-input" min="0" max="10" value="5" step="1"
                           aria-label="Escala de intensidade de 0 a 10" aria-valuemin="0" aria-valuemax="10" aria-valuenow="5">
                    <div class="scale-value-display" id="scale-display" aria-live="polite" aria-atomic="true">5</div>
                    <button id="scale-submit" class="btn-primary" type="button">Confirmar →</button>
                </div>
            `;
        }

        html += '</div>';
        block.innerHTML = html;
        questionContainer.appendChild(block);

        // Tooltip toggle
        const tooltipBtn = block.querySelector('.tooltip-btn');
        const tooltipContent = block.querySelector('.tooltip-content');
        tooltipBtn.addEventListener('click', () => {
            const isHidden = tooltipContent.classList.toggle('hidden');
            tooltipBtn.setAttribute('aria-expanded', String(!isHidden));
        });

        // Eventos de resposta
        if (question.q_type === 'sn') {
            block.querySelectorAll('button[data-answer]').forEach(btn => {
                btn.addEventListener('click', () => handleAnswer(question.code, btn.dataset.answer));
            });

            // Teclado: S = sim, N = não
            const keyHandler = (e) => {
                if (e.key === 's' || e.key === 'S') { handleAnswer(question.code, 's'); document.removeEventListener('keydown', keyHandler); }
                if (e.key === 'n' || e.key === 'N') { handleAnswer(question.code, 'n'); document.removeEventListener('keydown', keyHandler); }
            };
            document.addEventListener('keydown', keyHandler);

        } else if (question.q_type === 'scale') {
            const rangeInput = document.getElementById('scale-input');
            const displayEl  = document.getElementById('scale-display');
            const submitBtn  = document.getElementById('scale-submit');

            rangeInput.addEventListener('input', () => {
                displayEl.textContent = rangeInput.value;
                rangeInput.setAttribute('aria-valuenow', rangeInput.value);
                // Cor dinâmica da escala
                const val = parseInt(rangeInput.value, 10);
                rangeInput.dataset.val = val;
            });

            submitBtn.addEventListener('click', () => {
                handleAnswer(question.code, rangeInput.value);
            });

            // Enter também confirma
            rangeInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') submitBtn.click();
            });
        }

        // Foco no primeiro botão de resposta
        setTimeout(() => {
            const firstBtn = block.querySelector('.btn-yes, #scale-submit');
            if (firstBtn) firstBtn.focus();
        }, 100);
    }

    function updateQuestionCounter() {
        if (questionCounter) {
            questionCounter.textContent = `Pergunta ${questionCount}`;
        }
    }

    function handleAnswer(code, answer) {
        triageState.answers[code] = answer;
        questionContainer.classList.add('hidden');
        questionContainer.innerHTML = '';
        getTriageStep();
    }

    // RESULTADO — PARTE A
    function renderResult(result) {
        triageSection.classList.add('hidden');
        resultSection.classList.remove('hidden');
        updateProgress('step-resultado');
        lastResult = result;

        if (result.destination === 'error') {
            resultContent.innerHTML = `
                <div class="result-main-card dest-default">
                    <p><strong>Não foi possível determinar o encaminhamento.</strong></p>
                    <p>${escapeHtml(result.justification)}</p>
                    <p style="margin-top:.75rem">Por favor, contacte o SNS24 <strong>(808 24 24 24)</strong> ou, em caso de emergência, ligue <strong>112</strong>.</p>
                </div>
            `;
            return;
        }

        const destClass = getDestinationClass(result.destination);
        const destLabel = formatDestination(result.destination);
        const destIcon  = getDestinationIcon(result.destination);
        const cf        = result.certainty || 0;
        const cfClass   = cf >= 80 ? 'high' : cf >= 55 ? 'medium' : 'low';
        const now       = new Date();
        const dateStr   = now.toLocaleDateString('pt-PT', { day: '2-digit', month: '2-digit', year: 'numeric' });
        const timeStr   = now.toLocaleTimeString('pt-PT', { hour: '2-digit', minute: '2-digit' });

        resultContent.innerHTML = `
            <div class="result-main-card ${destClass}">
                <div class="result-dest-row">
                    <span class="result-mode-badge">Parte A — Regras Manuais</span>
                    <span class="result-timestamp">${dateStr} ${timeStr}</span>
                </div>
                <div class="result-dest-label">Encaminhamento recomendado</div>
                <div class="destination-display">
                    <div class="destination-icon-wrapper ${destClass}" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">${destIcon}</svg>
                    </div>
                    <span class="destination-label ${destClass}">${destLabel}</span>
                </div>

                <div class="certeza-section">
                    <div class="certeza-label-row">
                        <span class="certeza-title">Grau de Certeza</span>
                        <span class="certeza-value">${cf.toFixed(1)}%</span>
                    </div>
                    <div class="certeza-bar-track" role="progressbar" aria-valuenow="${cf.toFixed(0)}" aria-valuemin="0" aria-valuemax="100" aria-label="Grau de certeza">
                        <div class="certeza-bar-fill ${cfClass}" id="certeza-bar" style="width:0%"></div>
                    </div>
                </div>

                <div class="result-user-row">
                    <span><strong>${escapeHtml(result.user.nome)}</strong></span>
                    <span>NIF: <strong>${result.user.nif}</strong></span>
                    <span>${result.user.idade} anos</span>
                </div>

                <div class="justificacao-box">
                    <strong>Justificação clínica</strong>
                    <p>${escapeHtml(result.justification)}</p>
                </div>
            </div>
        `;

        requestAnimationFrame(() => {
            setTimeout(() => {
                const bar = document.getElementById('certeza-bar');
                if (bar) bar.style.width = `${Math.min(cf, 100)}%`;
            }, 100);
        });
    }

    // COPIAR RESULTADO
    copyResultBtn.addEventListener('click', () => {
        if (!lastResult) return;
        const destLabel  = formatDestination(lastResult.destination);
        const cf         = lastResult.certainty ? lastResult.certainty.toFixed(1) : 'N/D';
        const now        = new Date();
        const dateStr    = now.toLocaleDateString('pt-PT');
        const timeStr    = now.toLocaleTimeString('pt-PT', { hour: '2-digit', minute: '2-digit' });

        const text = [
            'TRIAGEM SNS24 — RELATÓRIO CLÍNICO',
            '==================================',
            `Data / Hora : ${dateStr} ${timeStr}`,
            `Utente      : ${lastResult.user.nome}`,
            `NIF         : ${lastResult.user.nif}`,
            `Idade       : ${lastResult.user.idade} anos`,
            '',
            `Encaminhamento : ${destLabel}`,
            `Grau de Certeza: ${cf}%`,
            '',
            `Justificação: ${lastResult.justification}`,
            '',
            'AVISO: Resultado orientativo. Não substitui avaliação médica.',
            'SNS24: 808 24 24 24 | Emergência: 112',
        ].join('\n');

        navigator.clipboard.writeText(text)
            .then(() => showToast('Resultado copiado para a área de transferência.', 'success'))
            .catch(() => showToast('Não foi possível copiar. Tente imprimir.', 'error'));
    });

    // HELPERS DE FORMATAÇÃO
    function formatDestination(dest) {
        const map = {
            emergencia_112:          'Emergência 112',
            urgencia_hospitalar:     'Urgência Hospitalar',
            consulta_medica:         'Consulta Médica',
            contacto_sns24:          'Contacto SNS24',
            linha_saude_mental:      'Linha Saúde Mental',
            autocuidados_vigilancia: 'Autocuidados com Vigilância',
            autocuidados:            'Autocuidados'
        };
        return map[dest] || dest.replace(/_/g, ' ');
    }

    function getDestinationClass(dest) {
        const map = {
            emergencia_112:          'dest-emergencia',
            urgencia_hospitalar:     'dest-urgencia',
            consulta_medica:         'dest-consulta',
            contacto_sns24:          'dest-sns24',
            linha_saude_mental:      'dest-mental',
            autocuidados_vigilancia: 'dest-vigilancia',
            autocuidados:            'dest-autocuidados'
        };
        return map[dest] || 'dest-default';
    }

    // SVG paths por tipo de encaminhamento (sem emojis)
    function getDestinationIcon(dest) {
        const map = {
            emergencia_112:          '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.6 3.41 2 2 0 0 1 3.58 1h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L7.91 8.15a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 15"/><line x1="8" y1="11" x2="8.01" y2="11"/>',
            urgencia_hospitalar:     '<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/><line x1="12" y1="5" x2="12" y2="9"/><line x1="10" y1="7" x2="14" y2="7"/>',
            consulta_medica:         '<path d="M16 2v4M8 2v4M3 10h18M5 4h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z"/><line x1="12" y1="14" x2="12" y2="18"/><line x1="10" y1="16" x2="14" y2="16"/>',
            contacto_sns24:          '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.6 3.41 2 2 0 0 1 3.58 1h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L7.91 8.15a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 15"/>',
            linha_saude_mental:      '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
            autocuidados_vigilancia: '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>',
            autocuidados:            '<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>'
        };
        return map[dest] || '<circle cx="12" cy="12" r="10"/>';
    }

    // IMPRESSÃO
    printResultBtn.addEventListener('click', () => window.print());

    // HISTÓRICO
    historyBtn.addEventListener('click', async () => {
        const response = await apiCall('/api/history', { nif: triageState.nif });
        if (response.error) { showError(idError, response.error); return; }
        renderHistory(response.history);
        idSection.classList.add('hidden');
        historySection.classList.remove('hidden');
    });

    closeHistoryBtn.addEventListener('click', () => {
        historySection.classList.add('hidden');
        idSection.classList.remove('hidden');
    });

    function renderHistory(history) {
        if (!history || history.length === 0) {
            historyContent.innerHTML = `
                <div class="history-empty">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="history-empty-icon" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="11" y1="9" x2="8" y2="9"/></svg>
                    <p>Não existem registos de triagens anteriores para este utente.</p>
                </div>
            `;
            return;
        }

        let html = `
            <table class="history-table">
                <caption class="sr-only">Histórico de triagens do utente</caption>
                <thead>
                    <tr>
                        <th scope="col">Data / Hora</th>
                        <th scope="col">Modo</th>
                        <th scope="col">Encaminhamento</th>
                        <th scope="col">Certeza</th>
                    </tr>
                </thead>
                <tbody>
        `;

        history.forEach(entry => {
            const modeLabel = entry.sintoma === 'triagem_ml'
                ? '<span class="badge-ml-small">ML</span>'
                : '<span class="badge-manual-small">Manual</span>';
            const destLabel = formatDestination(entry.destino);
            const destClass = getDestinationClass(entry.destino);

            html += `
                <tr>
                    <td>${escapeHtml(entry.data)}</td>
                    <td>${modeLabel}</td>
                    <td><span class="destination-label ${destClass}" style="font-size:.8rem;padding:.2rem .7rem">${destLabel}</span></td>
                    <td><strong>${parseFloat(entry.certeza).toFixed(0)}%</strong></td>
                </tr>
            `;
        });

        html += '</tbody></table>';
        historyContent.innerHTML = html;
    }

    // REINICIAR TRIAGEM
    restartButton.addEventListener('click', resetAll);

    function resetAll() {
        triageState   = { nif: null, answers: {}, fluxo: null };
        currentUser   = null;
        questionCount = 0;
        lastResult    = null;
        stopSessionTimer();

        hideAllSections();
        idSection.classList.remove('hidden');
        nifForm.classList.remove('hidden');
        registrationForm.classList.add('hidden');
        welcomeContainer.classList.add('hidden');
        questionContainer.innerHTML = '';
        questionContainer.classList.remove('hidden');
        resultContent.innerHTML = '';
        nifInput.value = '';
        nomeInput.value = '';
        dataNascimentoInput.value = '';
        nifInput.classList.remove('input-valid', 'input-invalid');
        welcomeAvatar.textContent = '?';
        userWelcome.innerHTML = '';
        welcomeNifDisplay.textContent = '';
        clearError(idError);
        clearError(triageError);
        updateProgress('step-utente');
        nifInput.focus();
    }

    function hideAllSections() {
        [idSection, fluxoSection, triageSection, resultSection,
         historySection].forEach(s => s.classList.add('hidden'));
    }

    // TEMA CLARO / ESCURO
    function applyTheme(theme) {
        document.body.classList.toggle('dark-mode', theme === 'dark');
        if (iconMoon && iconSun) {
            iconMoon.classList.toggle('hidden', theme === 'dark');
            iconSun.classList.toggle('hidden',  theme !== 'dark');
        }
        themeToggleBtn.setAttribute('aria-label', theme === 'dark' ? 'Mudar para tema claro' : 'Mudar para tema escuro');
    }

    themeToggleBtn.addEventListener('click', () => {
        const isDark = document.body.classList.contains('dark-mode');
        const next   = isDark ? 'light' : 'dark';
        localStorage.setItem('sns24-theme', next);
        applyTheme(next);
    });

    applyTheme(localStorage.getItem('sns24-theme') || 'light');

    // UTILITÁRIOS
    function showError(el, msg) {
        el.textContent = msg;
        el.style.display = 'flex';
    }

    function clearError(el) {
        el.textContent = '';
        el.style.display = '';
    }

    function escapeHtml(str) {
        if (typeof str !== 'string') return str;
        return str
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    // ── CHATBOT RAG ──────────────────────────────────────────────────────────
    const RAG_URL      = 'http://localhost:8001/chat';
    const RAG_HEALTH   = 'http://localhost:8001/health';

    const chatFab      = document.getElementById('chat-fab');
    const chatPanel    = document.getElementById('chat-panel');
    const chatMessages = document.getElementById('chat-messages');
    const chatInput    = document.getElementById('chat-input');
    const chatSendBtn  = document.getElementById('chat-send-btn');
    const chatClearBtn = document.getElementById('chat-clear-btn');
    const chatFabOpen  = document.getElementById('chat-fab-icon-open');
    const chatFabClose = document.getElementById('chat-fab-icon-close');
    const chatStatusDot= document.getElementById('chat-status-dot');

    let chatHistorico  = [];   // [[user, bot], ...]
    let chatAberto     = false;
    let ragOnline      = false;
    let chatUtente     = null; // { nif, nome, idade } identificado no chat

    // Verifica se o servidor RAG está disponível
    async function verificarRag() {
        try {
            const r = await fetch(RAG_HEALTH, { signal: AbortSignal.timeout(15000) });
            ragOnline = r.ok;
        } catch {
            ragOnline = false;
        }
        chatStatusDot.className = 'chat-status-dot ' + (ragOnline ? 'online' : 'offline');
        chatStatusDot.title = ragOnline ? 'Assistente disponível' : 'Assistente indisponível';
    }
    verificarRag();
    setInterval(verificarRag, 15000);

    // Abre/fecha o painel
    chatFab.addEventListener('click', () => {
        chatAberto = !chatAberto;
        chatPanel.classList.toggle('hidden', !chatAberto);
        chatFabOpen.classList.toggle('hidden', chatAberto);
        chatFabClose.classList.toggle('hidden', !chatAberto);
        if (chatAberto) {
            abrirChat();
        }
    });

    const chatLockOverlay = document.getElementById('chat-lock-overlay');

    function abrirChat() {
        if (!currentUser) {
            chatMessages.innerHTML = '';
            chatLockOverlay.classList.remove('hidden');
            chatInput.disabled = true;
            chatSendBtn.disabled = true;
            return;
        }

        // Utilizador autenticado — remove overlay e mostra saudação (só uma vez)
        chatLockOverlay.classList.add('hidden');
        chatInput.disabled = false;
        chatInput.placeholder = 'Descreva os seus sintomas...';
        if (!chatUtente) {
            chatUtente = currentUser;
            chatMessages.innerHTML = '';
            adicionarMensagem(
                `Olá, ${currentUser.nome.split(' ')[0]}. Sou o assistente de triagem SNS24. Descreva os seus sintomas.`,
                'bot'
            );
        }
        chatInput.focus();
        scrollChat();
    }

    // Activa/desactiva botão de envio
    chatInput.addEventListener('input', () => {
        chatSendBtn.disabled = chatInput.value.trim() === '';
        // auto-resize
        chatInput.style.height = 'auto';
        chatInput.style.height = Math.min(chatInput.scrollHeight, 100) + 'px';
    });

    // Enviar com Enter (Shift+Enter = nova linha)
    chatInput.addEventListener('keydown', e => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            if (!chatSendBtn.disabled) enviarMensagem();
        }
    });

    chatSendBtn.addEventListener('click', enviarMensagem);

    // Limpar conversa
    chatClearBtn.addEventListener('click', () => {
        chatHistorico = [];
        chatUtente    = null;
        chatMessages.innerHTML = '';
        abrirChat();
    });

    function adicionarMensagem(texto, tipo) {
        const wrapper = document.createElement('div');
        wrapper.className = `chat-msg chat-msg-${tipo}`;
        const bubble = document.createElement('span');
        bubble.className = 'chat-msg-text';
        // destaca emergências
        if (tipo === 'bot' && texto.toLowerCase().startsWith('liga já para o 112')) {
            bubble.classList.add('emergency');
        }
        bubble.textContent = texto;
        wrapper.appendChild(bubble);
        chatMessages.appendChild(wrapper);
        scrollChat();
        return wrapper;
    }

    function mostrarTyping() {
        const wrapper = document.createElement('div');
        wrapper.className = 'chat-msg chat-msg-bot chat-typing';
        wrapper.id = 'chat-typing-indicator';
        wrapper.innerHTML = `<span class="chat-msg-text"><span class="dot"></span><span class="dot"></span><span class="dot"></span></span>`;
        chatMessages.appendChild(wrapper);
        scrollChat();
    }

    function removerTyping() {
        const el = document.getElementById('chat-typing-indicator');
        if (el) el.remove();
    }

    function scrollChat() {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    async function enviarMensagem() {
        const texto = chatInput.value.trim();
        if (!texto) return;

        adicionarMensagem(texto, 'user');
        chatInput.value = '';
        chatInput.style.height = 'auto';
        chatSendBtn.disabled = true;

        if (!ragOnline) {
            adicionarMensagem('O assistente está indisponível. Certifique-se que o servidor RAG está a correr (python servidor_rag_gpu.py).', 'bot');
            return;
        }

        mostrarTyping();

        // Aviso de demora após 10 segundos
        const avisoTimeout = setTimeout(() => {
            const aviso = document.getElementById('chat-aviso-demora');
            if (!aviso) {
                const el = document.createElement('div');
                el.id = 'chat-aviso-demora';
                el.className = 'chat-msg chat-msg-bot';
                el.innerHTML = '<span class="chat-msg-text" style="font-style:italic;opacity:0.7">A processar... o modelo pode demorar alguns segundos.</span>';
                chatMessages.appendChild(el);
                scrollChat();
            }
        }, 10000);

        try {
            const resp = await fetch(RAG_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ mensagem: texto, historico: chatHistorico, utente: chatUtente }),
                signal: AbortSignal.timeout(180000)  // 3 minutos — modelos locais são lentos
            });

            clearTimeout(avisoTimeout);
            document.getElementById('chat-aviso-demora')?.remove();
            removerTyping();

            if (!resp.ok) throw new Error('Erro do servidor');

            const dados = await resp.json();
            const resposta = dados.resposta || 'Sem resposta.';
            adicionarMensagem(resposta, 'bot');
            chatHistorico.push([texto, resposta]);

            // Limita histórico a 10 trocas para não sobrecarregar o prompt
            if (chatHistorico.length > 10) chatHistorico.shift();

        } catch (err) {
            clearTimeout(avisoTimeout);
            document.getElementById('chat-aviso-demora')?.remove();
            removerTyping();
            if (err.name === 'TimeoutError') {
                adicionarMensagem('O assistente demorou demasiado a responder. O modelo pode estar sobrecarregado — tente novamente.', 'bot');
            } else {
                adicionarMensagem('Ocorreu um erro ao contactar o assistente. Verifique se o servidor RAG está a correr.', 'bot');
            }
        }
    }

});