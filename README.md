# Shaman Assist 0.3.0 Beta 1

تحديث الهيرو تالنت: أضيفت 34 خانة تنبيه موزعة على التخصصات لـStormbringer وTotemic وFarseer، مع قراءة الهيرو الحالي تلقائيًا أثناء اللعب. تفاصيل التغطية والبفات وحدود التتبع في `HERO-TALENTS.md`.

في General تقدر تختار Auto أو أي تخصص يدويًا للإعدادات والتست. Test All وEdit Layout يعرضان التخصص المختار مع تنبيهات شجرتي الهيرو المتاحتين له. استخدم Next وPrevious أسفل القائمة للوصول إلى الصفحات الجديدة. تنبيهات اللعب تتبع تخصصك والهيرو الفعليين.

يدعم **Enhancement وElemental وRestoration**، مع اكتشاف التخصص تلقائيًا عند الدخول والتبديل، وإعدادات ومواقع مستقلة لتنبيهات كل تخصص.

- **Elemental**: Lava Surge، Tempest Buff، Ascendance مع تايم لاين، Lightning Shield، وتذكير إمبيو السلاح الرئيسي.
- **Restoration**: Tidal Waves، Ascendance مع تايم لاين، Water Shield، Earth Shield على نفسك، وتذكير Earthliving للسلاح الرئيسي. Earth Shield هنا يتتبع البف على اللاعب فقط وليس أعضاء المجموعة.
- **Test All وEdit Layout** يعرضان تنبيهات التخصص الحالي فقط، وتعرض القائمة صفحاته فقط. تغيير التخصص يوقف المعاينة ويلغي تعديل المواقع غير المحفوظ.

## التركيب

1. فك الضغط وانسخ مجلد `ShamanAssist` إلى مجلد اللعبة `_retail_/Interface/AddOns/`.
2. تأكد أن المسار النهائي هو `AddOns/ShamanAssist/ShamanAssist.toc`.
3. شغّل اللعبة وفعّل Shaman Assist من قائمة AddOns. إذا كانت اللعبة مفتوحة أثناء التركيب، أعد تشغيلها.
4. افتح الإعدادات بكتابة `/sha` أو من زر الميني ماب.

## الموجود في النسخة

- **Tempest Buff**: عرض مستقل للبف الفعلي مع الستّاكات والمدة عند توفرها، منفصل عن تنبيه جاهزية Tempest القديم.
- **Ascendance**: تايم لاين مفعّل افتراضيًا بالوقت المتبقي الفعلي، يتحدث عند تمديد البف ويختفي عند انتهائه أو إزالته.
- **Doom Winds**: أيقونة للبف مع الوقت المتبقي، وخيار إظهار تايم لاين.
- لكل عرض جديد خيارات مستقلة للأيقونة والنص والوقت والستاكات والشريط وعرضه ولونه. الشريط قابل للتحريك بعد فك قفل المواقع. تشملها معاينة **Test All**.

- زر **Test All** ثابت أعلى صفحات الإعدادات: يعرض جميع الأيقونات والنصوص والـGlow وشريط الستّاكات معًا لمدة 20 ثانية، حتى للخيارات المعطلة، دون تعديل إعداداتك. زر **Stop Test** يوقف المعاينة، وتتوقف أيضًا عند إغلاق الإعدادات أو دخول القتال.
- أيقونة تجمع Enhancement وElemental وRestoration، مستخدمة في الميني ماب وقائمة الأدونات ونافذة الإعدادات.

- عدّاد Maelstrom Weapon مع شريط وعتبة تنبيه قابلة للتعديل من 1 إلى 10، والافتراضي 10.
- تنبيهات Stormstrike وHot Hand / Lava Lash وTempest.
- تنبيه Crash Lightning عند التأكد من غياب البف، ويختفي عند وجوده. مفعّل أثناء القتال افتراضيًا مع Glow على زر المهارة، ويمكن تغيير إعداداته من `/sha` ثم Crash Lightning.
- تذكير Lightning Shield عندما يتأكد الأدون أنه مفقود.
- تذكير غياب التعزيز المؤقت للسلاح الرئيسي والثانوي. وجود **أي** تعزيز مؤقت يوقف التذكير؛ لا يتحقق الأدون من نوع التعزيز.
- أيقونات ونصوص قابلة للتحريك، تنبيه صوتي اختياري، وأربعة أشكال Glow.
- خيارات Glow مستقلة لأزرار المهارات وCooldown Manager.
- عناصر إعدادات وثيمات مأخوذة من DK Assist، وزر للميني ماب ودعم Addon Compartment.
- إعدادات مستقلة باسم `ShamanAssistDB`؛ يمكن تثبيته بجانب DK Assist.

## الأوامر

| الأمر | الوظيفة |
|---|---|
| `/sha` | فتح الإعدادات |
| `/sha test` | معاينة جميع التنبيهات لمدة 20 ثانية؛ تجربة التنبيه المنفرد مدتها 6 ثوانٍ |
| `/sha stop` | إيقاف المعاينة |
| `/sha unlock` | إظهار المعاينة والسماح بتحريك الأيقونات والنصوص |
| `/sha lock` | تثبيت المواقع وإيقاف المعاينة |
| `/sha rescan` | إعادة اكتشاف أزرار المهارات وCooldown Manager خارج القتال |
| `/sha status` | عرض حالة المصادر والتنبيهات في الشات |

## حدود النسخة والتجربة

- إذا لم تظهر البفات الجديدة أثناء القتال، أضف **Tempest وAscendance وDoom Winds** إلى **Tracked Buffs** في Blizzard Cooldown Manager ثم نفّذ `/sha rescan` خارج القتال. يستخدم الأدون حالة البف ومعرّف مدته من الإطار المعروف عندما تتعذر القراءة المباشرة.
- لا يبدأ تايم لاين من مجرد ضغط المهارة ولا يعتمد مدة ثابتة: المدة مأخوذة من البف. إذا عُرف وجود البف ولم تتوفر مدته، تظهر `--`؛ والبف الذي تُؤكد القراءة أنه بلا نهاية يعرض `Active`.
- تحديث أرقام البفات وشريطها يعمل فقط عند وجود عرض مؤقت ظاهر، ولا يمسح البفات أو الأزرار في كل إطار.

- استُهدفت واجهة Retail `120100`. اجتازت الملفات فحص Lua 5.1 واختبارات منطقية ببيئة محاكاة؛ **لم تُجرَّب داخل اللعبة ولم يُفحص شكلها بصريًا داخل WoW**.
- تنبيهات البروكات تتبع إشارات Blizzard أو بف اللاعب المقروء؛ ليست اقتراحًا لدورة ضرر مثالية ولا تضغط المهارات.
- إذا حُجبت معلومات الستّاكات أثناء القتال، يُعرض العدد مباشرةً من API العرض إن أمكن، وإلا تظهر `?`. لا يعمل تنبيه العتبة على عدد محجوب، ولا يُخمّن العدد.
- لتشغيل المصدر البديل لتنبيه Crash Lightning أثناء القتال، أضفه إلى **Tracked Buffs** في Blizzard Cooldown Manager ثم نفّذ `/sha rescan` خارج القتال. يستخدم الأدون حالة البف المقروءة؛ إذا لم تتوفر، يوقف التنبيه بدل التخمين. وضع المهارة في قائمة الكولداونات وحده لا يحدد وجود البف.
- تنبيه Crash Lightning لا يشترط عدد أهداف أو جاهزية المهارة؛ يتابع غياب البف كما طلبت، بما في ذلك النسخة البديلة من البف.
- غياب بيانات البف أثناء القتال لا يُعتبر دليلًا على فقدانه، ولذلك قد يتوقف تذكير Lightning Shield أثناء القتال.
- بروك Tempest مرتبط بوجوده في البناء المختار؛ لا يُفترض أنه متاح لكل بناء.
- اكتشاف الأزرار يشمل Blizzard وBartender وDominos وElvUI وEllesmere عبر أسماء وإطارات معروفة. يلزم التحقق داخل اللعبة مع إصدار واجهتك.
- إذا تغيرت صفحة الأزرار أو الماكرو أثناء القتال، تُمسح الروابط القديمة ويؤجل اكتشافها حتى نهاية القتال؛ الأيقونات المستقلة تستمر.
- أول تجربة مقترحة: افتح `/sha` ثم **Test all alerts**، وبعدها اختبر على دمية تدريب. استخدم `/sha status` لتحديد المصدر إذا لم يظهر تنبيه.

## Attribution

Shared settings controls, theme palettes, glow wrappers, minimap launcher and button discovery patterns are adapted from DK Assist 2.1.9. The original MIT license is included in `LICENSE`. Bundled LibStub and LibCustomGlow retain their source headers.

Current API signatures were checked against Blizzard's generated documentation mirrored in [wow-ui-source](https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_APIDocumentationGenerated), including [aura data](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitAuraDocumentation.lua), [specializations](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SpecializationInfoDocumentation.lua) and [temporary enchants](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/PaperDollInfoDocumentation.lua). The Enhancement aura IDs were cross-checked against [SimulationCraft's Shaman implementation](https://github.com/simulationcraft/simc/blob/midnight/engine/class_modules/sc_shaman.cpp).
