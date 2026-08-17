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

## 情绪表演:结构化分镜(默认格式)

**情绪表演一律用结构化分镜格式,不用连续 prose。** 依据官方 `[S20-FMT-01]`:Seedance 2.0 推荐**分镜(numbered shots)+ 分时段描述**,顶部先声明镜数/时长/画幅,再按 `0–3s / 3–6s / 6–10s / 10–15s` 之类**时间段**(不是精确卡秒)分镜;precise 卡秒不稳定。这与用户已验证格式一致(见 `references/longform-performance-pattern.md` §6 与 `tests/fixtures/seedance25-30s-farewell-monologue.verified.md`)。

正文结构(= 验证格式):

```text
[身份契约:唯一主体 + 参考图绑定 + 正向一致性清单]
[场景总纲:镜数 + 时长 + 情绪强度 + 时空 + 氛围 + 光 + 镜头关系 + 一个主运镜;焦点/画外对象声明]
[单一情感事实(或带一次转折的主线)+ 情绪叠层]

## Shot 01 (0–[t1]s) — [状态名]
[该段:一个外显生理动作 → 可选一句对白 → 说完的反应]

## Shot 02 ([t1]–[t2]s) — [状态名]
……

## Performance Direction
[重述身份、光、镜头、情感事实,作为贯穿约束]
```

- **情绪转折(多情绪)必须每一拍一个 Shot**,尤其把**回落/压回单列一个 Shot 并写具体降温动作**(移视→慢呼气→肩落→眼神变冷→礼貌性收尾),否则转折在连续 prose 里会被揉平、读作假(教训见 `[USER-SD20-01]`)。
- 时间段仅作节奏参考,跨段动作连续,不在边界重起势。
- ≤10s 装完整转折偏紧;回落不稳时优先拉长到 12–15s,而不是加更多泪。

## 单镜渲染(仅限极简单一动作、非情绪片段)

仅当片段是单一、非情绪、可一句话说清的动作时,才可用连续 prose;**任何情绪表演走上一节的结构化分镜**。

- 以 `when / at first / after a beat / only then / end with` 建立相对顺序。
- 一个镜头只解决一个主要表演问题。
- 微表演优先使用稳定中近景或特写。
- 每次主动判断镜头；静止也要服务观看责任。使用运动时只保留一个主 Camera Unit。

这不是填空模板。句子数量、节点与顺序必须按场景裁剪；不需要的 control、dialogue 或 release 应删除。

## 交互表演与实体契约

Seedance 与 Kling 共用 `references/interaction-performance.md` 的交互分类、实体契约、首帧门禁和物理可行性结论：

- `source_preflight: block` 或 `render_mode: incompatible` 时不输出 Prompt；
- `render_mode: direct_action` 时只写主角色一侧可独立成立的交流行动；
- `render_mode: implied_contact_experimental` 时明确这是待验证的接触暗示；
- `render_mode: invite_and_wait` 时把 ending 停在邀请与等待；
- 隐藏对象时，连续 prose 只写获准主体的动作，不虚构对方回应、持续接触、承重或物体交换；
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

- **时长**:一次生成约 15 秒上限。30 秒情绪弧**默认切成多条可运行 prompt(`video1`/`video2`…)**,每条 ≤15s,按情绪阶段边界切分,`video2` 用续写/末帧承接 `video1` 的结束状态,每条都重复身份契约与单一情感事实(见 `references/longform-performance-pattern.md` §4.1)。**不以删内容为默认**;只有用户明确要单条成片时才压缩到 ~15s。单条 clip 内部仍可用 `First shot... Then cut to... End on...` 分段。
- **L4 分段**:只用 `Shot N` 或相对时序(`when / after a beat / only then`);依据 `[S2-CAM-01]` 边界,不写秒级精确时间点。
- **L1 身份**:用参考素材职责绑定(身份/服装)+ 正文正向声明一致性;不发明 `@Image1` 语法。
- **L5 重述**:压到一镜时完整重述;拆多镜时把持续约束分摊进每镜起点。
- **越肩隐藏对象**:按 `references/interaction-performance.md`,连续 prose 只写获准主体,不虚构对方回应或接触。
- 情绪外化、慢速连续小动作、结尾停在悬而未决——三模型通用,全部保留。

## Environment 模式

环境空镜不虚构角色行动逻辑。连续 prose 按 `空间基线 → Camera Unit 触发 → 一个主路径 → 信息或规模变化 → 落幅` 组织：

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
