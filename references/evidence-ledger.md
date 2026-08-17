# 证据门禁与来源登记

## 能力核实与验证覆盖

- **official 能力最后核实：2026-08-13(Seedance 2.5 于 2026-08-17 补充核实)。** 本文件登记的 Kling / Seedance 官方入口、字段与能力可能已更新;输出前以当前官方入口为准,发现变化时按下方晋升规则重新登记,不沿用过期能力做承诺。
- **真实成片验证覆盖有限。** 目前 `user_verified` 成片证据:Kling 3.0 Standard 单人 `actor_cut`(见 `[USER-K3-01]`~`[USER-K3-04]`)、Seedance 2.5 30s 单人告别独白(`[USER-SD25-01]`),以及一条 Seedance 2.0 情绪转折失败教训(`[USER-SD20-01]`:连续 prose 承载转折读作假)。
- **`environment`(空镜/航拍)与 `narrative` 多镜多人**目前只有自测 forward-test,**无真实生成验证**,应按设计级(`experimental`)置信度对待,不宣称成片质量已验证。跨文件设计立场见 `references/shared-principles.md`。

## 晋升规则

本规则由用户于 2026-08-11 明确要求：写入 skill 的模型能力、失败原因与稳定修复，必须有正确来源或经过用户明确生成验证。

- `official`：模型厂商官方文档明确支持，可写成平台事实；保留适用版本和边界。
- `user_approved`：用户明确批准的 Skill 工作流、输出契约或证据政策；可作为设计要求，不构成模型效果验证。
- `user_verified`：用户报告了实际生成结果；只在相同模型、工作流、输入条件和约束范围内成立。
- `experimental`：只有修复假设，尚无官方依据或用户成片验证；可以作为待验证输出，不能进入稳定规则。
- `rejected`：用户实测无效或与官方资料冲突；不得再次作为默认建议。

新增稳定规则必须引用下列证据编号。推断不得借“工程经验”绕过门禁。

表演方法与成片评价的外部来源登记在 `references/acting-craft.md`：

- `[ACT-RADA-01]`：目的、规定情境、倾听与逐刻响应；
- `[ACT-TRINITY-01]`：镜头表演、画外互动、景别与 Playback；
- `[ACT-LAMDA-01]`：角色解释与技术执行分层；
- `[ACT-RESEARCH-01]`：表情可识别性不等于真实性；
- `[ACT-RESEARCH-02]`：面部动作不是固定情绪指纹；
- `[USER-CRAFT-01]`：用户批准的演技提升引擎设计边界；
- `[USER-CRAFT-02]`：用户批准的未指定风格解析顺序。
- `[USER-INTERACTION-01]`：用户批准的交互分类、实体许可、物理可行性和动作识别度工作流。
- `[CAM-ASC-01]` 至 `[CAM-ASC-04]`：人物/行动驱动、独立导演视点、功能性运镜、银幕方向与运动工具选择；
- `[CAM-LOCAL-01]`：本地 Cinematique 只作术语参考；
- `[USER-CAMERA-01]`：用户批准的 Camera Unit、环境模式与镜头执行过滤边界。

上述表演与镜头方法的详细来源登记在 `references/acting-craft.md` 与 `references/camera-direction.md`。它们支持生成推导与证据边界，不构成 Seedance 或 Kling 的能力保证。模型能力和稳定修复仍只按本文件下列平台证据与用户成片验证登记。

## Kling 官方来源

### [K-I2V-01] 图生视频的主体运动写法

- 状态：`official`
- 来源：[Kling AI Image to Video Guide](https://kling.ai/quickstart/image-to-video-guide)，章节 “Prompt = Subject + Movement, Background + Movement” 与 Tips。
- 发布：2025-11-24；访问：2026-08-11。
- 支持：图生视频的核心写法是主体＋运动状态；官方建议使用简单词语和句式，动作符合物理规律并与输入图像中可能发生的运动相符。
- 边界：该指南没有承诺纯 Prompt 能硬锁人物站位。

### [K-I2V-02] 输入场景与复杂物理动作边界

- 状态：`official`
- 来源：[Kling AI Image to Video Guide](https://kling.ai/quickstart/image-to-video-guide)，图生视频说明与 Tips。
- 发布：2025-11-24；访问：2026-08-12。
- 支持：图生视频已由输入图提供场景，正文重点描述其中主体及其运动；官方建议动作符合物理规律，并说明显著偏离输入图可能导致镜头切换或转场，复杂物理运动仍有难度。
- 不支持：首帧干净即可保证后续不新增实体；单边模拟互惠接触必然可读；负面词可以稳定删除或阻止实体。

### [K-MC-01] Motion Control 的动作来源与职责

- 状态：`official`
- 来源：[Kling VIDEO 3.0 Motion Control User Guide](https://kling.ai/quickstart/motion-control-user-guide)，章节 “Motion Control” 与 “How to Use Kling VIDEO 3.0 Motion Control”。
- 发布：2026-03-05；访问：2026-08-11。
- 支持：Motion Control 可从上传动作视频或 Motion Library 为图像中的一个角色分配动作；官方将其描述为对动作与表情的精确控制。
- 不支持：不构成每次输出绝对无误的保证。

### [K-MC-02] 输出跟随动作参考

- 状态：`official`
- 来源：[Kling VIDEO 3.0 Motion Control User Guide](https://kling.ai/quickstart/motion-control-user-guide)，章节 “Character Orientation” 及上传动作参考说明。
- 访问：2026-08-11。
- 支持：人物动作和表情会跟随动作参考；在相应朝向模式下，朝向或机位也可能跟随参考。上传动作视频的生成长度与参考长度一致，复杂或过快动作可能只提取有效连续片段。
- 不支持：补充 Prompt 可以覆盖动作参考中已有的路径或节奏。

### [K-MC-03] 动作参考质量要求

- 状态：`official`
- 来源：[Kling VIDEO 3.0 Motion Control User Guide](https://kling.ai/quickstart/motion-control-user-guide)，章节 “How to Achieve the Desired Outputs”。
- 访问：2026-08-11。
- 支持：动作参考应单镜连续、人物持续可见，避免剪切、镜头变化或机位运动；稳定、适中的速度更合适；官方同时建议使用最小位移的动作参考。
- 边界：“原地完成目标动作”来自本次用户的硬约束；官方来源只支持用相应动作参考进行驱动及尽量减少位移。

### [K-PROMPT-01] 可见动作描述

- 状态：`official`
- 来源：[AI Motion Prompts for Kling AI](https://kling.ai/blog/kling-ai-motion-prompts-guide)，章节 “Movement in the Kling 3.0 Era” 与 FAQ。
- 发布：2026-07-03；访问：2026-08-11。
- 支持：用观众可见的姿态、速度、方向、地面接触、镜头关系和情绪意图描述动作。

### [K-PROMPT-02] 复杂动作的简化与复核

- 状态：`official`
- 来源：[AI Motion Prompts for Kling AI](https://kling.ai/blog/kling-ai-motion-prompts-guide)，章节 “Nuanced Performance through Gestures and Expressions”、“Review and Refinement” 与 “Visible Cause and Effect in Motion”。
- 访问：2026-08-11。
- 支持：手势应描述路径、表情、时机、身体朝向和接收对象；出现解剖或时序问题时，先简化场景、减少竞争动作，并在生成后检查动作清晰度、主体一致性和变形再迭代。

### [K-CAM-01] Kling 3.0 文本运镜与单镜负荷

- 状态：`official`
- 来源：[Kling AI Camera Control: Master Push, Pull, Pan & Tilt](https://kling.ai/blog/kling-ai-camera-control-video-guide)。
- 发布：2026-06-29；访问：2026-08-13。
- 支持：Kling VIDEO 3.0/Omni 可通过正文描述 push、pull、pan、tilt、track、orbit 与 static；官方建议把镜头连接到主体和场景，写清方向，并让单镜优先一个主要 camera action。官方还将文本、参考图像、视频输入和 storyboard instructions 列为镜头规划入口，示例使用起幅/落幅、速度与稳定性质。
- 边界：官方没有在该文档中给所有入口定义统一素材绑定字段或精确路径复现等级，并明确说明生成具有概率性、需要测试变化；清楚正文或普通视频输入不等于精确相机轨迹或关键帧保证。

### [K-CAM-02] 独立 Camera Movement 控件

- 状态：`official`
- 来源：[Kling AI Camera Movement](https://kling.ai/quickstart/ai-camera-control-guide)。
- 发布：2025-11-24；访问：2026-08-13。
- 支持：官方 Camera Movement 功能列出 horizontal、vertical、zoom、pan、tilt、roll 六类基础运动和四种 Master Shots，并允许在界面调整位移幅度。
- 边界：不同 UI 或合作方入口可能不暴露该控件；本 skill 只输出概念配置，不伪造统一 API 字段，也不把 UI 控件与冲突的正文运镜叠加。

### [K-CAM-03] Start/End Frames 与主体连续性

- 状态：`official`
- 来源：[Kling VIDEO 3.0 Model User Guide](https://kling.ai/quickstart/klingai-video-3-model-user-guide)，Capabilities Upgrade 与 Image-to-Video/Element Reference。
- 发布：2026-02-06；访问：2026-08-13。
- 支持：Kling VIDEO 3.0 支持 Start & End Frames-to-Video；元素引用可帮助主体在 zoom、pan、tilt 或镜头变化时保持特征一致。
- 边界：支持端点输入和主体引用不等于中间路径、速度、遮挡或几何补间精确；Motion Control 仍是人物动作来源，不是相机路径控制。

### [K-MS-02] Kling 3.0 微型多镜与逐镜镜头设计

- 状态：`official`
- 来源：[Kling VIDEO 3.0 Multi-Shot: Create Structured Cinematic Sequences](https://kling.ai/blog/kling-video-3-multi-shot-guide)。
- 发布：2026-07-28；访问：2026-08-13。
- 支持：VIDEO 3.0 与 3.0 Omni 支持 3–15 秒 Multi-Shot/Custom Multi-Shot；官方当前说明自动与自定义模式最多 6 镜，自定义模式可逐镜指定时长、景别、视点、叙事内容和 camera movement，并建议每镜承担清楚任务。
- 边界：逐镜控制是 shot-level 结构，不等于镜内运镜关键帧或人物微动作精确。

## Seedance 官方来源

### [S2-CAM-01] 多模态镜头参考与 camera planning

- 状态：`official`
- 来源：[Seedance 2.0 Official Launch](https://seed.bytedance.com/en/blog/seedance-2-0-official-launch) 与 [Seedance 2.0 Model Page](https://seed.bytedance.com/en/seedance2_0)。
- 发布：2026-02-12；访问：2026-08-13。
- 支持：Seedance 2.0 支持文本、图像、视频和音频输入，可参考素材中的构图、动作、camera movement、镜头语言与运动节奏，也支持 prompt-driven camera planning、文字分镜参考和 15 秒多镜音视频输出。
- 边界：官方的 controllability 与 full control 表述不构成每次生成精确路径、秒点、复杂多轴运动或几何稳定保证；精确复现仍需参考素材与成片验证。

### [S25-CAP-01] Seedance 2.5 单次 one-take、参考理解与时间戳编辑

- 状态：`official`(仅限下列官方确认项)
- 来源：[Seedance 2.5 Model Page](https://seed.bytedance.com/en/seedance2_5)(2026-08-17 一手核实)；[Introducing Seedance 2.5](https://seed.bytedance.com/en/blog/one-take-creation-flexible-referencing-introducing-seedance-2-5)(限定官方域名搜索摘要佐证,博客正文未逐字抓取)。
- 官方确认:单次生成最长 30 秒,可扩展(模型页原文 “extend twice”;博客称多轮 extension)以延长;reference-to-video 能理解参考视频的意图、构图与镜头语言,超出单纯 motion transfer;单次最多 30 图 + 10 视频 + 10 音频参考素材;支持专业运镜与 performance blocking;支持对音视频的时间戳级编辑控制。
- **第三方待核实(不作官方保证)**:原生 1080p / 4K 分辨率、prompt 对秒级 timestamp 的稳定响应、“给素材编号并绑定角色”的具体写法——均来自第三方指南,官方页未确认(4K 的官方表述指向另一模型的图像,不是 2.5 视频);以实测为准。
- 不支持:one-take 不构成 30 秒内身份零漂移、口型完美同步、负面词稳定服从或精确相机关键帧保证。

### [S25-FORMULA-01] Seedance 2.5 四段 prompt 结构(第三方归纳)

- 状态：`experimental`(第三方指南归纳自官方发布示例,官方示例正文未一手核实)
- 来源：第三方指南 [Seedance 2.5 Prompt Guide](https://suno.bi/en/blog/seedance-2-5-prompt-guide) 对官方发布示例的归纳;核实：2026-08-17。
- 支持:四段结构——编号素材引用 → 一句话总纲(主体+地点+事件+风格+运镜)→ 按 timestamp 或 Shot N 的具体情节 → 收尾持续约束;配合情绪外化、缓慢连续小动作、正向措辞。与 `[USER-SD25-01]` 一致,该样本已验证有效。
- 边界:不是一手官方文档;作为写作约定使用,换场景仍需成片验证,不作模型保证。

### [S20-FMT-01] Seedance 2.0 官方推荐分镜 + 分时段结构

- 状态：`official`
- 来源：《Doubao Seedance 2.0 系列提示词指南》[docs 82379/2222480](https://docs.volcengine.com/docs/82379/2222480?lang=zh);用户提供入口 [docs 82379/2607689](https://docs.volcengine.com/docs/82379/2607689?lang=zh)。
- 核实：2026-08-17(官方页为 JS 渲染,正文未逐字抓取,结构经限定官方来源的搜索摘要 + 多份第三方指南交叉印证;发现出入以官方页为准)。
- 官方要点:Seedance 2.0 推荐**分镜(numbered shots)结构 + 分时段描述**;顶部先声明镜数、总时长、画幅,再按 `0–3s / 3–6s / 6–10s / 10–15s` 等**时间段**(非精确卡秒)分镜;精确卡秒不稳定。推荐结构含主体/场景/动作/运镜/分时段/风格等维度;时长 4–15 秒;多模态输入总数 ≤12(≤9 图、≤3 视频、≤3 音频)。
- 用法:情绪表演默认用该分镜结构(= 用户验证格式),不用连续 prose。

## 用户实测与要求

### [USER-K3-01] 原地约束失败

- 状态：`user_verified`
- 用户报告日期：2026-08-11。
- 条件：Kling 3.0 Standard、8 秒、单人演员 Cut、稳定单镜中近景、无台词；Prompt 包含向镜头前倾、迎接/拥抱姿态及随后回落，同时多次写明不迈步和保持原位。
- 观察结果：人物仍向前走动，随后退回。
- 允许结论：该 Prompt 与配置组合没有满足零位移要求。
- 禁止扩写：不能据此认定某个单词是唯一原因，也不能认定未经生成测试的新措辞已经修复。

### [USER-K3-02] 原地文本修复通过

- 状态：`user_verified`
- 用户确认日期：2026-08-11。
- 条件：Kling 3.0 Standard、8 秒、单人演员 Cut、稳定单镜中近景、无台词；人物久别重逢表演保持原地。
- 修复组合：Prompt 开头定义人物站定、双脚持续承重、人物—镜头距离不变；主要动作限制在眼神、面部、肩部和双臂；高潮只让肩部舒展、双臂横向打开；删除前倾、朝镜头靠近、迎接/拥抱及全身返回任务。
- 用户结果：测试可行。
- 允许结论：该文本组合可作为上述匹配条件下的已验证修复。
- 边界：模型版本、工作流、景别、主要动作方向或输入条件改变时重新验收；不扩写成 Kling Standard 对所有原地动作的保证。

### [USER-K3-03] 对镜击掌的外部实体排除失败

- 状态：`user_verified`
- 用户报告日期：2026-08-12。
- 条件：Kling 3.0、8 秒、单人演员 Cut、对镜击掌；正文已经要求只有主角色，并多次禁止第二个人、他人的手和其他身体局部。
- 用户结果：生成中仍出现不属于主角色的手或人物，未满足实体硬排除。
- 允许结论：这些 Prompt 与配置组合没有稳定满足外部实体排除要求；重复禁止词不是已验证修复。
- 禁止扩写：没有对应成片可逐帧定位，不能认定某个交互词、负面词或动作方向是唯一原因。

### [USER-K3-04] 实体排除成立但击掌动作不可读

- 状态：`user_verified`
- 用户确认日期：2026-08-12。
- 条件：Kling 3.0、8.042 秒、单人演员 Cut、对镜交互；输入首帧没有额外人物或他人的手。用户提供成片 `视频节点 17.mp4`，本轮以 0.1 秒间隔检查动作过程。
- 用户结果：成片没有出现外部人物或他人的手，主要失败是动作；动作手横扫身体并经过额头，随后掌心向下前伸，无法读成击掌。
- 允许结论：该 Take 的实体排除成立而动作识别度失败；两项必须分开验收。
- 禁止扩写：不能据此声称删除交互对象语义稳定解决实体增生，也不能把单次动作误读归因于某一个词。

### [USER-SD25-01] Seedance 2.5 长篇告别独白范式通过

- 状态：`user_verified`
- 用户确认日期：2026-08-17。
- 条件：Seedance 2.5、30 秒单镜 one-take、图片参考(`{{Mixed 1}}`=身份、`{{Mixed 2}}`=服装);夜晚室内、冷光、越肩对方视角保留模糊肩部、焦点锁定女主脸;单一情感事实(仍爱着 / 已决定离开 / 正逼自己说出口)+ 情绪叠层;4 镜递进(中近→极近)、每镜对白夹在外显生理动作之间、结尾停在情绪悬而未决;结尾以「表演指导」块重述身份/光/镜头/情感事实。
- 用户结果：经用户验证,非常满意。
- 允许结论：该五层骨架(见 `references/longform-performance-pattern.md`)在上述条件下可作为已验证的 Seedance 2.5 长篇情绪表演范式,属**单一情绪递进**形态。
- 逐字存档：`tests/fixtures/seedance25-30s-farewell-monologue.verified.md`。
- 禁止扩写：仅限该模型、时长、图参考与内容类型与**单一情绪递进**形态;**双人交流形态目前无成片验证,为设计级(`experimental`)**;不外推为 Seedance 2.0 / Kling 3.0 或任意情绪场景的通用保证,换模型/时长/镜头/形态需重新验收。

### [USER-SD20-01] Seedance 2.0 连续 prose 承载情绪转折失败

- 状态：`user_verified`
- 用户报告日期：2026-08-17。
- 条件：Seedance 2.0、10 秒、单主体在短片内做一次情绪大起大落/反转(维持体面→被戳破→破口→压回冷下来);Prompt 用**连续 causal prose**、非分镜结构。
- 用户结果：整体情绪转折"很假"。
- 允许结论:两条独立教训——(1)**格式**:连续 prose 会把 beat 揉平,情绪表演应改用结构化分镜(= 用户验证格式),符合官方 `[S20-FMT-01]`,已推动 v1.7.x 全类型结构化;(2)**导演**:短时长(约 10–15s)内的情绪反转本身不符合表演规律,用户据此**移除"多情绪转折"形态**(设计边界见 `references/longform-performance-pattern.md` §1.1)。
- 禁止扩写:格式结论定位到 Prompt 格式,不把某一措辞判为唯一原因;导演结论是设计决策,不据此断定 Seedance 2.0 完全不能表现情绪层次。

### [USER-PROMPT-01] Prompt 自足性、必写项与需求保真

- 状态：`user_approved`
- 用户要求日期：2026-08-17。
- 触发：实际调用中出现三处使用问题——(1)图生视频时误删场景/氛围/光/可见生理信号描述;(2)把"承接上一段/反打/同一个夜晚"等模型不可用的叙事上下文写进 Prompt 正文;(3)**用户明确的构图(过肩)在改为图生视频的 revision 中被静默改成正面,prompt 阶段无核对,直到成片回看才发现**。
- 要求：(a)**每条 Prompt 独立自足**,模型对上一段视频与整体剧情无记忆;叙事承接/反打/上下文只用于内部设计,不进正文;连续性用显式可见状态(首帧、姿态、泪光、位置、未说完的话)与 extension/末帧表达。(b)**场景/氛围/光/可见生理信号,以及构图/视角/景别(过肩/正面/POV/俯拍)都是每条 Prompt 的必写项**,图生视频也不省略;i2v 只是不重复首帧已提供的空间几何,不删氛围、光、可见信号或构图。(c)**用户明确的硬要求在任何 revision 中不得因内部推断静默删改**;不确定是否保留时先确认。(d)**输出前逐项核对**:用户列出的每一项硬要求都要能在最终 Prompt 正文里对上,在 prompt 阶段完成,不等成片回看。
- 边界：这是用户批准的输出规则,不构成模型对场景、构图或连续性稳定服从的保证。

### [USER-POLICY-01] Skill 证据门禁

- 状态：`user_approved`
- 用户要求日期：2026-08-11。
- 要求：所有新增 Skill 内容必须有正确资讯来源，或经过用户明确验证后再写入；禁止以未经验证的推断充当稳定规则。

### [USER-CRAFT-01] 演技提升引擎设计

- 状态：`user_approved`。
- 用户批准日期：2026-08-12。
- 要求：表演提升作为主流程；用具体对象、WANT、tactic、反馈与 ending 生成逐刻表演；使用自适应分析深度和风格契约；评价只作为生成前质量门及成片反馈闭环。
- 边界：这是用户批准的 skill 工作流，不宣称为行业唯一表演体系，也不提高模型底层动作服从或物理稳定性。

### [USER-CRAFT-02] 未指定风格的解析顺序

- 状态：`user_approved`。
- 用户批准日期：2026-08-12。
- 要求：优先采用用户明确风格、参考素材与既有上下文，其次使用可观察的场景线索；仍无依据时只作满足强度、景别与动作预算的最小风格假设并说明，不默认写实或克制。
- 边界：这是 skill 决策规则，不构成模型能力、行业唯一方法或某种风格质量更高的结论。

### [USER-INTERACTION-01] 角色交互表演引擎设计

- 状态：`user_approved`。
- 用户批准日期：2026-08-12。
- 要求：将交互类型、目标是否可见、实体所有权、接触与外部支撑、隐藏后的动作可读性和渲染模式分开推导；硬排除先做首帧门禁；单边接触暗示只用于短暂互惠动作并保持实验状态；持续接触和物体交换缺少必要对象时降级或阻断。
- 边界：这是用户批准的生成工作流，不构成 Kling、Seedance 或其他模型能够稳定排除实体、正确完成接触或服从数量约束的能力保证。

### [USER-CAMERA-01] 镜头导演与运镜引擎设计

- 状态：`user_approved`。
- 用户批准日期：2026-08-13。
- 要求：新增 `environment` 模式；角色与环境镜头都主动判断静止或移动；用 Camera Unit 建立起幅、触发、一个主运镜、停止和落幅；候选策略按观看关系而非同义术语区分；支持单镜及 15 秒内微序列；模型执行来源与镜头意图分离。
- 边界：这是用户批准的 skill 决策与验收流程，不构成模型能够稳定执行复杂路径、扩写首帧外空间或命中精确相机关键帧的能力保证。
