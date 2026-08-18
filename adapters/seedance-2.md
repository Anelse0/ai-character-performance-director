# Seedance 2.0 适配器

## 适用范围

面向 Seedance 2.0 标准版的表演 Prompt。入口、模型 ID、参考标签和音频配置可能不同；只输出正文能够承担的表演内容，平台配置另行说明。

## 渲染原则

把语义对象写成一段连续因果 prose：

```text
shot and identity/reference responsibility
→ baseline and current goal
→ when trigger happens...
→ at first / after a beat / only then...
→ primary visible change + optional readable support
→ action/control/choice
→ dialogue after action, if any
→ end with explicit residue
→ short targeted guardrails
```

标签只是这里的规划顺序，最终正文不用显示 `TRIGGER:`、`END STATE:` 等作者字段。

## 镜头设计与参考职责

先从 `references/camera-direction.md` 接收 Camera Unit。依据 `[S2-CAM-01]`，Seedance 2.0 可通过文本进行 camera planning，并可从图像、视频或文字分镜参考构图、景别、镜头运动和运动节奏；这些是能力入口，不是精确路径保证。

选择执行方式：

- `prompt`：简单静止、单轴移动、一次注意转移或单一跟随关系；
- `video_reference`：需要复现复杂路径、运动节奏或多轴协调时，由明确绑定的视频承担 camera movement；
- `custom_multishot`：复杂性来自 15 秒内多个不同镜头任务；
- 分镜图/拍摄脚本参考：承担景别、角度、镜头顺序或视觉结构，不自动承担精确运动轨迹。

正文必须保留 camera subject、起幅、一个主运镜、与主体动作的关系、停止条件和落幅。视频参考已经承担路径和节奏时，正文只补充镜头目的、主体/场景责任与结束可读性，不重复编排另一条路径。

完整环绕、复合升降横移、dolly zoom、精确长镜头或镜头与复杂人物动作同步变化时，优先要求视频参考或简化；没有参考时标记 `experimental`，不把长文本称为精确控制。

## 结构化分镜(默认格式,所有类型)

**所有 Prompt(情绪表演、剧情、空镜/环境等,不限类型)一律用结构化分镜格式,不用连续 prose 段落。** 依据官方一手 `[S20-FMT-01]`:分镜时序用 `镜头 1 / 镜头 2 / 镜头 3` 组织;**Seedance 2.0 不响应时间戳,只响应镜头序号**——官方原文「模型对精确时间(如 0–3 秒)的支持不稳定,强行限制时长可能导致生成结果异常」「不强制限制每段时长,优先让模型根据剧情自然生成节奏」。**2.0 的 Shot 标题不写时间标注**(时间段标注仅限 Seedance 2.5)。单一不可切分的动作写成单个 `Shot`(N=1),而非回退 prose。

每镜按官方四部分组织:①运镜或切换方式 ②主体动作与表情 ③位置/空间变化 ④音频信息(音效/人声/沉默)。

正文结构(= 验证格式,2.0 版无时间标注):

```text
[身份契约:主体定义句式绑定参考图 + 正向一致性清单]
[场景总纲:镜数 + 时长 + 情绪强度 + 时空 + 氛围 + 光 + 镜头关系 + 一个主运镜;焦点/画外对象声明]
[单一情感事实(或恒定核心+层)+ 情绪叠层]

## 镜头 1 — [状态名]
[运镜/切换 → 一个外显生理动作 → 可选一句对白(delivery)→ 反应 → 本镜声音]

## 镜头 2 — [状态名]
……

## Performance Direction
[重述身份、光、镜头、情感事实与声音,作为贯穿约束]
```

官方主体定义句式:`将<图片 N>中的[2–3 个稳定特征]定义为<主体 N>`,后续持续用同一标签;未定义时用 `张三@图片1`。官方动作规则同样适用:肢体细化+幅度/速度/力度量化;优先低缓连续小动作;写明前后动作惯性承接;一个镜头只指定 1 种运镜。

- **场景/氛围/光/可见生理信号必写**(时空、氛围、冷/暖光、脸上明暗层次,以及眼中湿润、泛红眼睑、唇部细微颤抖、呼吸节奏等"需清晰可见"的表演信号),**即使图生视频也不省略**;i2v 只是不重复首帧已提供的空间几何/未知空间,不等于删掉氛围、光与可见信号(`[USER-PROMPT-01]`)。
- **每条 Prompt 独立自足**:模型对上一段视频无记忆,**不写"承接上一段 / 反打 / 同一个夜晚 / 刚说完"**等上下文;连续性用显式首帧可见状态(姿态/泪光/位置/未说完的话)表达。
- 时间段仅作节奏参考,跨段动作连续,不在边界重起势。

## 单个 Shot 内的写法

即使只有一个镜头,也写成一个 `Shot 01 (0–[t]s)` 块,**不用裸 prose 段落**。相对时序词只在 Shot 内部组织 beat 时使用:

- 以 `when / at first / after a beat / only then / end with` 建立相对顺序。
- 一个 Shot 只解决一个主要表演问题。
- 微表演优先使用稳定中近景或特写。
- 每次主动判断镜头；静止也要服务观看责任。使用运动时只保留一个主 Camera Unit。

这不是填空模板。beat 数量、节点与顺序必须按场景裁剪；不需要的 control、dialogue 或 release 应删除。

## 交互表演与实体契约

Seedance 与 Kling 共用 `references/interaction-performance.md` 的交互分类、实体契约、首帧门禁和物理可行性结论：

- `source_preflight: block` 或 `render_mode: incompatible` 时不输出 Prompt；
- `render_mode: direct_action` 时只写主角色一侧可独立成立的交流行动；
- `render_mode: implied_contact_experimental` 时明确这是待验证的接触暗示；
- `render_mode: invite_and_wait` 时把 ending 停在邀请与等待；
- 隐藏对象时，正文只写获准主体的动作，不虚构对方回应、持续接触、承重或物体交换；
- 短暂互惠动作只能称为待验证的接触暗示，并用相对时序写清动作路径、表面朝向、停点和收势；
- 空间邀请以等待结束，不把画外对象写成已经进入画面；
- 物体交换所需物体必须已在首帧出现或作为明确输入素材绑定；仅允许新增物体不满足交换前提；
- 实体排除与动作可读性分别作为成功标准。

这些规则只控制 Prompt 决策，不构成 Seedance 对实体排除或接触动作稳定性的保证。

## 剧情与多镜

- 连续互动能在 3–5 个主 beats 内完成时优先单镜，保留 onset 与互动连续性。
- 必须拆镜时，用 `First shot... Then cut to... End on...` 描述镜头任务和因果承接。
- 逐镜秒数只能视为软段落提示；不要承诺镜内面部动作精确卡秒。
- 每镜明确 reaction owner，并把上一镜 residue 写入下一镜起点。
- 每镜只有一个 Camera Unit；换角度但没有新增动作、信息、关系或节奏责任的镜头应删除。
- 15 秒微序列中的 camera end frame、screen direction 与主体出画方向要传入下一镜。

## 长篇情绪表演适配

单主体持续情绪独白/告别按 `references/longform-performance-pattern.md` 的五层骨架渲染。Seedance 2.0 与 2.5 的关键差异在于**它不是 30 秒 one-take**,故做降级适配:

- **时长**:一次生成约 15 秒上限。30 秒情绪弧**默认切成多条可运行 prompt(`video1`/`video2`…)**,每条 ≤15s,按情绪阶段边界切分,每条都重复身份契约与单一情感事实(见 `references/longform-performance-pattern.md` §4.1)。**接续方式按官方口径:情绪递进/长对话属「文戏」,`video2` 优先用视频延长(向后延长 video1)产出**,保持连贯一镜;剧情转折/快节奏才独立生成分段拼接(`[S20-FMT-01]`)。延长任务直接用 `<视频N>` 指代,不写「参考 <视频N>」。**不以删内容为默认**;只有用户明确要单条成片时才压缩到 ~15s。
- **素材配置**(官方):按四种功能角色配置——角色锚定/场景定调/运镜参考/节奏氛围,推荐共 4–5 个素材;不用满上限(≤9 图、≤3 视频、≤3 音频、总数 ≤12),过多会导致特征优先级混乱。
- **L4 分段**:只用 `Shot N` 或相对时序(`when / after a beat / only then`);依据 `[S2-CAM-01]` 边界,不写秒级精确时间点。
- **L1 身份**:用参考素材职责绑定(身份/服装)+ 正文正向声明一致性;不发明 `@Image1` 语法。
- **L5 重述**:压到一镜时完整重述;拆多镜时把持续约束分摊进每镜起点。
- **越肩隐藏对象**:按 `references/interaction-performance.md`,正文只写获准主体,不虚构对方回应或接触。
- 情绪外化、慢速连续小动作、结尾停在悬而未决——三模型通用,全部保留。

## Environment 模式

环境空镜不虚构角色行动逻辑。写成一个或多个 `Shot` 块(顶部声明镜数/时长/画幅),按 `空间基线 → Camera Unit 触发 → 一个主路径 → 信息或规模变化 → 落幅` 组织：

- 航拍、俯拍、POV 或手持只定义视点/质感，另写实际路径；
- 背景群众、车辆、水面或树木只保留一个主要环境运动层；
- 图生视频需要大幅展示首帧外未知空间时，说明几何风险并简化或使用参考素材；
- 不用 `sweeping cinematic aerial`、器材或分辨率词替代方向、停止和结束构图。

## 对白

- 说话者姓名、动作、delivery 与精确短句相邻。
- 明确 speaker order 和 listener reaction。
- 只有命名 speaker articulates speech；该约束属于 Prompt 目标，不是口型保证。
- 台词前保留准备 beat，台词后写闭口与 aftermath。
- 多说话者、长对白和口型仍需多次生成验证。

## 参考素材

明确每个参考的职责：身份、场景、动作节奏、声音。若用户未说明实际入口，不发明 `@Image1` 等语法；改为在“配置”中描述应如何绑定，正文只保留身份连续性目标。

参考职责示意：

```text
配置：人物参考用于身份；视频参考只用于动作节奏；音频参考只用于音色。
正文：Keep [character]'s identity stable while following the restrained movement rhythm...
```

## 护栏

放在正文末尾，保持少量并优先正向：

```text
restrained movement; shoulders remain quiet; one purposeful gaze shift;
hands stay on the table except for one grip-and-release action
```

不要用长串 Negative Acting Constraints，也不要把 `subtle / internal` 当成主要动作。

## 不得宣称

- 精确到 0.5–1 秒的面部 beat；
- 完美多说话者口型；
- 表演类 Negative Prompt 稳定服从；
- 任何 Prompt 长度甜点区；
- Seedance 对所有微表演必然优于其他模型。

## 输出形态

````markdown
### Seedance 2.0 配置
[仅列人物/场景/镜头参考职责、时长、画幅、音频等需要用户在入口设置的内容]

### Seedance 2.0 Prompt
```text
[连续、可复制正文]
```
````
