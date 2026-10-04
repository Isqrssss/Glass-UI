-- Localización integrada. Las claves no traducidas conservan el texto original y pueden añadirse desde la API.
local Localization = {}

Localization.Languages = {
    { Code = "en", Name = "English" },
    { Code = "es", Name = "Español" },
    { Code = "pt", Name = "Português" },
    { Code = "fr", Name = "Français" },
    { Code = "de", Name = "Deutsch" },
    { Code = "it", Name = "Italiano" },
    { Code = "ru", Name = "Русский" },
    { Code = "zh", Name = "中文（简体）" },
    { Code = "ja", Name = "日本語" },
    { Code = "ko", Name = "한국어" },
    { Code = "ar", Name = "العربية" },
    { Code = "tr", Name = "Türkçe" },
}

local names = {}
for _, language in ipairs(Localization.Languages) do
    names[language.Name] = language.Code
end

local dictionaries = {
    es = {
        Dashboard="Panel", Buttons="Botones", Toggles="Interruptores", Sliders="Deslizadores",
        Inputs="Entradas", Dropdowns="Desplegables", Selectors="Selectores", Lists="Listas",
        Cards="Tarjetas", Visuals="Visuales", Animations="Animaciones", Settings="Ajustes",
        Language="Idioma", English="Inglés", ['Español']="Español", ['Português']="Portugués", ['Français']="Francés",
        Deutsch="Alemán", Italiano="Italiano", ['Русский']="Ruso", ["中文（简体）"]="Chino simplificado",
        ['日本語']="Japonés", ['한국어']="Coreano", ['العربية']="Árabe", ['Türkçe']="Turco",
        ["Interface Language"]="Idioma de la interfaz", ["Select the interface language"]="Selecciona el idioma de la interfaz",
        ["Detected from Roblox account language; you can change it here."]="Detectado desde el idioma de tu cuenta de Roblox; puedes cambiarlo aquí.",
        ["Settings"]="Ajustes", ["Safe-Unload Framework"]="Descargar interfaz de forma segura",
        ["Dynamic Keybind Active (G)"]="Atajo dinámico activo (G)", ["Primary System Action"]="Acción principal del sistema",
        ["Ghost Action"]="Acción secundaria", ["Confirm Change"]="Confirmar cambio", ["Secondary Confirm"]="Confirmación secundaria",
        ["Enable Canvas Overlays"]="Activar efectos de nieve", ["Snowfall"]="Nevada", ["Master Volume"]="Volumen principal",
        ["Display Name"]="Nombre visible", ["Session Note"]="Nota de sesión", ["Quality Preset"]="Calidad",
        ["Particle Renderer"]="Motor de partículas", ["Window Anchor"]="Posición de ventana",
        ["Glass accent"]="Color del vidrio", ["Brightness"]="Brillo", ["Opacity"]="Opacidad",
        ["Color and glass opacity"]="Color y opacidad del vidrio", ["Apply"]="Aplicar",
    },
    pt = {
        Dashboard="Painel", Buttons="Botões", Toggles="Alternâncias", Sliders="Controles deslizantes",
        Inputs="Entradas", Dropdowns="Menus suspensos", Selectors="Seletores", Lists="Listas",
        Cards="Cartões", Visuals="Visuais", Animations="Animações", Settings="Configurações",
        Language="Idioma", English="Inglês", ['Español']="Espanhol", ['Português']="Português", ['Français']="Francês",
        Deutsch="Alemão", Italiano="Italiano", ['Русский']="Russo", ["中文（简体）"]="Chinês simplificado",
        ['日本語']="Japonês", ['한국어']="Coreano", ['العربية']="Árabe", ['Türkçe']="Turco",
        ["Interface Language"]="Idioma da interface", ["Select the interface language"]="Selecione o idioma da interface",
        ["Detected from Roblox account language; you can change it here."]="Detectado pelo idioma da sua conta Roblox; você pode alterá-lo aqui.",
        ["Safe-Unload Framework"]="Descarregar interface com segurança", ["Dynamic Keybind Active (G)"]="Atalho dinâmico ativo (G)",
        ["Primary System Action"]="Ação principal do sistema", ["Ghost Action"]="Ação secundária", ["Confirm Change"]="Confirmar alteração",
        ["Secondary Confirm"]="Confirmação secundária", ["Enable Canvas Overlays"]="Ativar efeitos de neve", ["Snowfall"]="Neve",
        ["Master Volume"]="Volume principal", ["Display Name"]="Nome de exibição", ["Session Note"]="Nota da sessão",
        ["Quality Preset"]="Qualidade", ["Particle Renderer"]="Renderizador de partículas", ["Window Anchor"]="Posição da janela",
        ["Glass accent"]="Cor do vidro", ["Brightness"]="Brilho", ["Opacity"]="Opacidade",
        ["Color and glass opacity"]="Cor e opacidade do vidro", ["Apply"]="Aplicar",
    },
    fr = {
        Dashboard="Tableau de bord", Buttons="Boutons", Toggles="Interrupteurs", Sliders="Curseurs",
        Inputs="Entrées", Dropdowns="Menus déroulants", Selectors="Sélecteurs", Lists="Listes",
        Cards="Cartes", Visuals="Visuels", Animations="Animations", Settings="Paramètres",
        Language="Langue", English="Anglais", ['Español']="Espagnol", ['Português']="Portugais", ['Français']="Français",
        Deutsch="Allemand", Italiano="Italien", ['Русский']="Russe", ["中文（简体）"]="Chinois simplifié",
        ['日本語']="Japonais", ['한국어']="Coréen", ['العربية']="Arabe", ['Türkçe']="Turc",
        ["Interface Language"]="Langue de l’interface", ["Select the interface language"]="Choisissez la langue de l’interface",
        ["Detected from Roblox account language; you can change it here."]="Détectée depuis la langue du compte Roblox ; modifiable ici.",
        ["Safe-Unload Framework"]="Fermer l’interface proprement", ["Dynamic Keybind Active (G)"]="Raccourci dynamique actif (G)",
        ["Primary System Action"]="Action principale", ["Ghost Action"]="Action secondaire", ["Confirm Change"]="Confirmer la modification",
        ["Secondary Confirm"]="Confirmation secondaire", ["Enable Canvas Overlays"]="Activer les effets de neige", ["Snowfall"]="Neige",
        ["Master Volume"]="Volume principal", ["Display Name"]="Nom affiché", ["Session Note"]="Note de session",
        ["Quality Preset"]="Qualité", ["Particle Renderer"]="Rendu des particules", ["Window Anchor"]="Position de la fenêtre",
        ["Glass accent"]="Couleur du verre", ["Brightness"]="Luminosité", ["Opacity"]="Opacité",
        ["Color and glass opacity"]="Couleur et opacité du verre", ["Apply"]="Appliquer",
    },
    de = {
        Dashboard="Übersicht", Buttons="Schaltflächen", Toggles="Umschalter", Sliders="Regler",
        Inputs="Eingaben", Dropdowns="Auswahllisten", Selectors="Auswahlen", Lists="Listen",
        Cards="Karten", Visuals="Visuals", Animations="Animationen", Settings="Einstellungen",
        Language="Sprache", English="Englisch", ['Español']="Spanisch", ['Português']="Portugiesisch", ['Français']="Französisch",
        Deutsch="Deutsch", Italiano="Italienisch", ['Русский']="Russisch", ["中文（简体）"]="Vereinfachtes Chinesisch",
        ['日本語']="Japanisch", ['한국어']="Koreanisch", ['العربية']="Arabisch", ['Türkçe']="Türkisch",
        ["Interface Language"]="Oberflächensprache", ["Select the interface language"]="Oberflächensprache auswählen",
        ["Detected from Roblox account language; you can change it here."]="Aus der Roblox-Kontosprache erkannt; hier änderbar.",
        ["Safe-Unload Framework"]="Oberfläche sicher schließen", ["Dynamic Keybind Active (G)"]="Dynamische Taste aktiv (G)",
        ["Primary System Action"]="Primäre Systemaktion", ["Ghost Action"]="Sekundäre Aktion", ["Confirm Change"]="Änderung bestätigen",
        ["Secondary Confirm"]="Sekundäre Bestätigung", ["Enable Canvas Overlays"]="Schneeeffekte aktivieren", ["Snowfall"]="Schneefall",
        ["Master Volume"]="Hauptlautstärke", ["Display Name"]="Anzeigename", ["Session Note"]="Sitzungsnotiz",
        ["Quality Preset"]="Qualität", ["Particle Renderer"]="Partikel-Renderer", ["Window Anchor"]="Fensterposition",
        ["Glass accent"]="Glasfarbe", ["Brightness"]="Helligkeit", ["Opacity"]="Deckkraft",
        ["Color and glass opacity"]="Glasfarbe und Deckkraft", ["Apply"]="Anwenden",
    },
    it = {
        Dashboard="Pannello", Buttons="Pulsanti", Toggles="Interruttori", Sliders="Cursori",
        Inputs="Input", Dropdowns="Menu a discesa", Selectors="Selettori", Lists="Elenchi",
        Cards="Schede", Visuals="Visuali", Animations="Animazioni", Settings="Impostazioni",
        Language="Lingua", English="Inglese", ['Español']="Spagnolo", ['Português']="Portoghese", ['Français']="Francese",
        Deutsch="Tedesco", Italiano="Italiano", ['Русский']="Russo", ["中文（简体）"]="Cinese semplificato",
        ['日本語']="Giapponese", ['한국어']="Coreano", ['العربية']="Arabo", ['Türkçe']="Turco",
        ["Interface Language"]="Lingua dell’interfaccia", ["Select the interface language"]="Seleziona la lingua dell’interfaccia",
        ["Detected from Roblox account language; you can change it here."]="Rilevata dalla lingua dell’account Roblox; puoi modificarla qui.",
        ["Safe-Unload Framework"]="Chiudi interfaccia in sicurezza", ["Dynamic Keybind Active (G)"]="Tasto dinamico attivo (G)",
        ["Primary System Action"]="Azione principale", ["Ghost Action"]="Azione secondaria", ["Confirm Change"]="Conferma modifica",
        ["Secondary Confirm"]="Conferma secondaria", ["Enable Canvas Overlays"]="Attiva effetti neve", ["Snowfall"]="Nevicata",
        ["Master Volume"]="Volume principale", ["Display Name"]="Nome visualizzato", ["Session Note"]="Nota sessione",
        ["Quality Preset"]="Qualità", ["Particle Renderer"]="Renderer particelle", ["Window Anchor"]="Posizione finestra",
        ["Glass accent"]="Colore del vetro", ["Brightness"]="Luminosità", ["Opacity"]="Opacità",
        ["Color and glass opacity"]="Colore e opacità del vetro", ["Apply"]="Applica",
    },
    ru = {
        Dashboard="Панель", Buttons="Кнопки", Toggles="Переключатели", Sliders="Ползунки",
        Inputs="Поля ввода", Dropdowns="Списки", Selectors="Выбор", Lists="Списки элементов",
        Cards="Карточки", Visuals="Визуальные эффекты", Animations="Анимации", Settings="Настройки",
        Language="Язык", English="Английский", ['Español']="Испанский", ['Português']="Португальский", ['Français']="Французский",
        Deutsch="Немецкий", Italiano="Итальянский", ['Русский']="Русский", ["中文（简体）"]="Упрощённый китайский",
        ['日本語']="Японский", ['한국어']="Корейский", ['العربية']="Арабский", ['Türkçe']="Турецкий",
        ["Interface Language"]="Язык интерфейса", ["Select the interface language"]="Выберите язык интерфейса",
        ["Detected from Roblox account language; you can change it here."]="Определён по языку аккаунта Roblox; его можно изменить здесь.",
        ["Safe-Unload Framework"]="Безопасно закрыть интерфейс", ["Dynamic Keybind Active (G)"]="Горячая клавиша активна (G)",
        ["Primary System Action"]="Основное действие", ["Ghost Action"]="Дополнительное действие", ["Confirm Change"]="Подтвердить изменение",
        ["Secondary Confirm"]="Дополнительное подтверждение", ["Enable Canvas Overlays"]="Включить снежные эффекты", ["Snowfall"]="Снегопад",
        ["Master Volume"]="Общая громкость", ["Display Name"]="Отображаемое имя", ["Session Note"]="Заметка сессии",
        ["Quality Preset"]="Качество", ["Particle Renderer"]="Рендер частиц", ["Window Anchor"]="Положение окна",
        ["Glass accent"]="Цвет стекла", ["Brightness"]="Яркость", ["Opacity"]="Непрозрачность",
        ["Color and glass opacity"]="Цвет и прозрачность стекла", ["Apply"]="Применить",
    },
    zh = {
        Dashboard="仪表板", Buttons="按钮", Toggles="开关", Sliders="滑块",
        Inputs="输入", Dropdowns="下拉菜单", Selectors="选择器", Lists="列表",
        Cards="卡片", Visuals="视觉效果", Animations="动画", Settings="设置",
        Language="语言", English="英语", ['Español']="西班牙语", ['Português']="葡萄牙语", ['Français']="法语",
        Deutsch="德语", Italiano="意大利语", ['Русский']="俄语", ["中文（简体）"]="简体中文",
        ['日本語']="日语", ['한국어']="韩语", ['العربية']="阿拉伯语", ['Türkçe']="土耳其语",
        ["Interface Language"]="界面语言", ["Select the interface language"]="选择界面语言",
        ["Detected from Roblox account language; you can change it here."]="根据 Roblox 账户语言检测；可在此更改。",
        ["Safe-Unload Framework"]="安全关闭界面", ["Dynamic Keybind Active (G)"]="动态快捷键已启用 (G)",
        ["Primary System Action"]="主要操作", ["Ghost Action"]="次要操作", ["Confirm Change"]="确认更改",
        ["Secondary Confirm"]="次要确认", ["Enable Canvas Overlays"]="启用飘雪效果", ["Snowfall"]="飘雪",
        ["Master Volume"]="主音量", ["Display Name"]="显示名称", ["Session Note"]="会话备注",
        ["Quality Preset"]="画质", ["Particle Renderer"]="粒子渲染器", ["Window Anchor"]="窗口位置",
        ["Glass accent"]="玻璃颜色", ["Brightness"]="亮度", ["Opacity"]="不透明度",
        ["Color and glass opacity"]="玻璃颜色与透明度", ["Apply"]="应用",
    },
    ja = {
        Dashboard="ダッシュボード", Buttons="ボタン", Toggles="トグル", Sliders="スライダー",
        Inputs="入力", Dropdowns="ドロップダウン", Selectors="セレクター", Lists="リスト",
        Cards="カード", Visuals="ビジュアル", Animations="アニメーション", Settings="設定",
        Language="言語", English="英語", ['Español']="スペイン語", ['Português']="ポルトガル語", ['Français']="フランス語",
        Deutsch="ドイツ語", Italiano="イタリア語", ['Русский']="ロシア語", ["中文（简体）"]="簡体字中国語",
        ['日本語']="日本語", ['한국어']="韓国語", ['العربية']="アラビア語", ['Türkçe']="トルコ語",
        ["Interface Language"]="インターフェース言語", ["Select the interface language"]="表示言語を選択",
        ["Detected from Roblox account language; you can change it here."]="Robloxアカウントの言語から検出。ここで変更できます。",
        ["Safe-Unload Framework"]="UIを安全に終了", ["Dynamic Keybind Active (G)"]="ショートカット有効 (G)",
        ["Primary System Action"]="メイン操作", ["Ghost Action"]="サブ操作", ["Confirm Change"]="変更を確定",
        ["Secondary Confirm"]="追加確認", ["Enable Canvas Overlays"]="雪の演出を有効化", ["Snowfall"]="雪",
        ["Master Volume"]="マスター音量", ["Display Name"]="表示名", ["Session Note"]="セッションメモ",
        ["Quality Preset"]="画質", ["Particle Renderer"]="パーティクル描画", ["Window Anchor"]="ウィンドウ位置",
        ["Glass accent"]="ガラスの色", ["Brightness"]="明るさ", ["Opacity"]="不透明度",
        ["Color and glass opacity"]="ガラスの色と不透明度", ["Apply"]="適用",
    },
    ko = {
        Dashboard="대시보드", Buttons="버튼", Toggles="토글", Sliders="슬라이더",
        Inputs="입력", Dropdowns="드롭다운", Selectors="선택기", Lists="목록",
        Cards="카드", Visuals="시각 효과", Animations="애니메이션", Settings="설정",
        Language="언어", English="영어", ['Español']="스페인어", ['Português']="포르투갈어", ['Français']="프랑스어",
        Deutsch="독일어", Italiano="이탈리아어", ['Русский']="러시아어", ["中文（简体）"]="중국어 간체",
        ['日本語']="일본어", ['한국어']="한국어", ['العربية']="아랍어", ['Türkçe']="터키어",
        ["Interface Language"]="인터페이스 언어", ["Select the interface language"]="인터페이스 언어 선택",
        ["Detected from Roblox account language; you can change it here."]="Roblox 계정 언어에서 감지됨. 여기서 변경할 수 있습니다.",
        ["Safe-Unload Framework"]="UI 안전하게 닫기", ["Dynamic Keybind Active (G)"]="동적 단축키 활성화 (G)",
        ["Primary System Action"]="기본 작업", ["Ghost Action"]="보조 작업", ["Confirm Change"]="변경 확인",
        ["Secondary Confirm"]="보조 확인", ["Enable Canvas Overlays"]="눈 효과 켜기", ["Snowfall"]="눈 내리기",
        ["Master Volume"]="마스터 볼륨", ["Display Name"]="표시 이름", ["Session Note"]="세션 메모",
        ["Quality Preset"]="품질 설정", ["Particle Renderer"]="파티클 렌더러", ["Window Anchor"]="창 위치",
        ["Glass accent"]="유리 색상", ["Brightness"]="밝기", ["Opacity"]="불투명도",
        ["Color and glass opacity"]="유리 색상 및 불투명도", ["Apply"]="적용",
    },
    ar = {
        Dashboard="لوحة المعلومات", Buttons="الأزرار", Toggles="مفاتيح التبديل", Sliders="أشرطة التمرير",
        Inputs="المدخلات", Dropdowns="القوائم المنسدلة", Selectors="المحددات", Lists="القوائم",
        Cards="البطاقات", Visuals="المظاهر", Animations="الحركات", Settings="الإعدادات",
        Language="اللغة", English="الإنجليزية", ['Español']="الإسبانية", ['Português']="البرتغالية", ['Français']="الفرنسية",
        Deutsch="الألمانية", Italiano="الإيطالية", ['Русский']="الروسية", ["中文（简体）"]="الصينية المبسطة",
        ['日本語']="اليابانية", ['한국어']="الكورية", ['العربية']="العربية", ['Türkçe']="التركية",
        ["Interface Language"]="لغة الواجهة", ["Select the interface language"]="اختر لغة الواجهة",
        ["Detected from Roblox account language; you can change it here."]="تم اكتشافها من لغة حساب Roblox؛ يمكنك تغييرها هنا.",
        ["Safe-Unload Framework"]="إغلاق الواجهة بأمان", ["Dynamic Keybind Active (G)"]="الاختصار الديناميكي نشط (G)",
        ["Primary System Action"]="الإجراء الرئيسي", ["Ghost Action"]="إجراء ثانوي", ["Confirm Change"]="تأكيد التغيير",
        ["Secondary Confirm"]="تأكيد ثانوي", ["Enable Canvas Overlays"]="تفعيل تأثيرات الثلج", ["Snowfall"]="تساقط الثلج",
        ["Master Volume"]="مستوى الصوت الرئيسي", ["Display Name"]="اسم العرض", ["Session Note"]="ملاحظة الجلسة",
        ["Quality Preset"]="الجودة", ["Particle Renderer"]="عارض الجسيمات", ["Window Anchor"]="موضع النافذة",
        ["Glass accent"]="لون الزجاج", ["Brightness"]="السطوع", ["Opacity"]="العتامة",
        ["Color and glass opacity"]="لون الزجاج وشفافيته", ["Apply"]="تطبيق",
    },
    tr = {
        Dashboard="Kontrol Paneli", Buttons="Düğmeler", Toggles="Anahtarlar", Sliders="Kaydırıcılar",
        Inputs="Girdiler", Dropdowns="Açılır Menüler", Selectors="Seçiciler", Lists="Listeler",
        Cards="Kartlar", Visuals="Görseller", Animations="Animasyonlar", Settings="Ayarlar",
        Language="Dil", English="İngilizce", ['Español']="İspanyolca", ['Português']="Portekizce", ['Français']="Fransızca",
        Deutsch="Almanca", Italiano="İtalyanca", ['Русский']="Rusça", ["中文（简体）"]="Basitleştirilmiş Çince",
        ['日本語']="Japonca", ['한국어']="Korece", ['العربية']="Arapça", ['Türkçe']="Türkçe",
        ["Interface Language"]="Arayüz dili", ["Select the interface language"]="Arayüz dilini seçin",
        ["Detected from Roblox account language; you can change it here."]="Roblox hesap dilinden algılandı; buradan değiştirebilirsiniz.",
        ["Safe-Unload Framework"]="Arayüzü güvenle kapat", ["Dynamic Keybind Active (G)"]="Dinamik kısayol etkin (G)",
        ["Primary System Action"]="Birincil sistem işlemi", ["Ghost Action"]="İkincil işlem", ["Confirm Change"]="Değişikliği onayla",
        ["Secondary Confirm"]="İkincil onay", ["Enable Canvas Overlays"]="Kar efektlerini etkinleştir", ["Snowfall"]="Kar yağışı",
        ["Master Volume"]="Ana ses düzeyi", ["Display Name"]="Görünen ad", ["Session Note"]="Oturum notu",
        ["Quality Preset"]="Kalite", ["Particle Renderer"]="Parçacık oluşturucu", ["Window Anchor"]="Pencere konumu",
        ["Glass accent"]="Cam rengi", ["Brightness"]="Parlaklık", ["Opacity"]="Opaklık",
        ["Color and glass opacity"]="Cam rengi ve opaklığı", ["Apply"]="Uygula",
    },
}

local localeAliases = {
    en="en", es="es", pt="pt", fr="fr", de="de", it="it", ru="ru",
    zh="zh", ja="ja", ko="ko", ar="ar", tr="tr",
}

function Localization.Normalize(code)
    if type(code) ~= "string" then return "en" end
    local prefix = code:lower():match("^([a-z]+)")
    return localeAliases[prefix] or "en"
end

function Localization.DetectLanguage(robloxLocaleId)
    return Localization.Normalize(robloxLocaleId)
end

function Localization.GetName(code)
    code = Localization.Normalize(code)
    for _, language in ipairs(Localization.Languages) do
        if language.Code == code then return language.Name end
    end
    return "English"
end

function Localization.GetCodeForName(name)
    return names[name] or "en"
end

function Localization.Translate(code, text)
    if type(text) ~= "string" then return text end
    code = Localization.Normalize(code)
    return (dictionaries[code] and dictionaries[code][text]) or text
end

function Localization.RegisterTranslations(code, translations)
    code = Localization.Normalize(code)
    if type(translations) ~= "table" then return false end
    dictionaries[code] = dictionaries[code] or {}
    for key, value in pairs(translations) do
        if type(key) == "string" and type(value) == "string" then
            dictionaries[code][key] = value
        end
    end
    return true
end

function Localization.GetNames()
    local result = {}
    for _, language in ipairs(Localization.Languages) do table.insert(result, language.Name) end
    return result
end

return Localization
