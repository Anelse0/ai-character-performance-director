---
name: ai-character-performance-director
description: 将角色意图、关系、刺激、情绪、对白、时长与镜头限制转换为可观察、可拍摄、非模板化的 AI 视频表演提示词。支持演员 Cut 与实际剧情表演，默认同时适配 Seedance 2.0 和 Kling 3.0。凡涉及 AI 角色演技、微表演、听戏、台词表演、克制、情绪高潮、多人对手戏或表演 Prompt，使用本 skill。
---

# AI Character Performance Director

把“角色感到什么”转换成“镜头里因何、按什么顺序发生哪些可观察变化”。不要把情绪词直接映射成固定表情，不要把行为线索当成心理诊断。

## 工作边界

本 skill 负责表演设计与模型 Prompt 渲染，不负责扩写完整故事、制作全片分镜或替用户决定与表演无关的美术风格。若用户已提供剧情，只补足表演所必需的信息。

支持两种模式：

- `actor_cut`：摄影机主要对着一个演员，表演本身是内容。可含无声反应、独白、短台词、画外刺激与听戏。
- `narrative`：人物行动实际改变剧情、关系、信息、距离、物件归属或决定。可含多人互动、对白和多镜头。

用户明确写“演员 Cut / Actor Cut / 剧情表演”时服从指定；否则自动判断。模式判断不确定但两种结果会实质不同时，只问一个简短问题。

## 必须读取的规则

每次调用先读取：

1. `references/acting-core.md`
2. 与模式对应的 `references/actor-cut.md` 或 `references/narrative-performance.md`
3. `references/quality-gates.md`

按需再读取：

- 有对白、画外音、听戏或多人话轮：`references/dialogue-listening.md`
- 有崩溃、强忍泪、惊恐、压抑愤怒、表白、分手、背叛等阈值场面：`references/climax-failures.md`
- 输出 Kling 且包含复杂动作、转头中的情绪变化、精确动作复现或 Motion Control：`references/kling-motion-control.md`
- 输出 Seedance：`adapters/seedance-2.md`
- 输出 Kling：`adapters/kling-3.md`
- 扩展新模型适配器：`adapters/adapter-contract.md`

不要为了“更完整”加载与当前请求无关的参考。

## 输入策略

用户可以只给自然语言。内部归一化为以下语义对象，但不要强迫用户填写表格：

```yaml
mode: auto | actor_cut | narrative
model: both | seedance2 | kling3_standard | kling3_omni | kling3_motion_control
duration:
characters:
relationship:
scene_state:
trigger:
want:
hide_or_conflict:
display_policy: reveal | restrain | deny | redirect
playable_strategy:
intensity: L1_leak | L2_breach | L3_dysregulation
dialogue:
shot_constraints:
references:
known_failures:
ending:
kling_workflow: auto | standard_single | custom_multi_shot | motion_control
motion_scope: localized | upper_body | full_body
motion_precision: approximate | repeatable | exact
motion_concurrency:
head_turn:
face_occlusion:
identity_sensitivity:
motion_reference: none | uploaded_video | motion_library
facial_element:
gaze_target:
gaze_behavior: establish | naturally_adjust | reacquire
expression_references:
```

只在缺失信息会改变表演策略时追问，例如：不知道刺激是什么，且“听到坏消息”与“看见证据”会产生不同的镜头行为。其他缺失项做最小合理推断，并在结果中用一行说明。

模型默认值：

- 用户未指定模型：同时输出 Seedance 2.0 与 Kling 3.0 两版。
- 用户指定模型：只输出该模型版本。
- Kling 未指定 Standard/Omni：单人或简单单镜用 Standard；只有角色/声音/多参考连续性确有需要时才用 Omni。
- Standard/Omni 是模型选择，single shot/Custom Multi-Shot/Motion Control 是执行工作流；不要把两者混为一类。

## 工作流

### 1. 判断模式

优先看镜头的叙事责任，不按人数机械判断：

- 表演用于展示角色状态，剧情环境只是刺激或背景：`actor_cut`。
- 表演产生可追踪的剧情后果：`narrative`。
- 单演员也可以是剧情表演；双人画面也可以由一个演员拥有 Actor Cut 式反应。

### 2. 建立角色行动逻辑

先确定：

```text
relationship → current WANT → optional HIDE/CONFLICT → trigger → playable strategy
```

`WANT` 是角色此刻试图取得的结果。只有克制、否认、改道或内在冲突存在时才补 `HIDE/CONFLICT`。

同一情绪至少在内部考虑两个不同策略，再依据关系、目标和剧情阶段选择。例如担忧可以表现为靠近帮助、保持距离照顾、否认转移话题或直接解决问题。不要调用固定“担忧脸”。

### 3. 评估 Kling 动作执行路径

仅在输出 Kling 时执行。先判断用户需要的是“近似生成”还是“精确复现”，再按 `references/kling-motion-control.md` 选择：

- 可串行描述的一条简单动作链：`standard_single`；
- 复杂性来自多个镜头任务，而不是单个连续身体动作：`custom_multi_shot`；
- 要求精确路径/次数/节奏，或复杂表情与转头、手部、身体运动需要高协调：`motion_control`。

若用户没有动作参考且 Motion Control 才能可靠满足要求，明确指出素材需求；不要把 Omni 当成精确动作驱动替代品。

### 4. 组装可裁剪 Beat Graph

按场景需要选择节点，不强迫走完整链条：

```text
baseline
→ trigger
→ immediate orient OR short processing
→ first observable change
→ action / control / redirect / choice
→ optional threshold and brief release
→ explicit end state
```

允许：

- 即时定向或短暂处理；
- 省略克制、升级、释放；
- 从高潮中段切入；
- 在阈值处有意切断；
- 克制成功直接成为结局。

### 5. 分配表演通道

每个 beat 首轮只安排一个主要表演意图：

- 简单表演：一个主通道，最多一个可读辅助通道；
- 复杂动作：允许完成同一动作所必需的机械联动，但按 `references/kling-motion-control.md` 写成一个 Motion Unit；
- 头、手、表情、重心各自承担不同表达任务时，必须删减、串行化或路由到 Motion Control，不能借“同时”强行合并。

动作必须同时满足：可见、有限、有方向、能排序、由刺激触发、服务角色目标。优先使用 `消失、停止、释放、返回、撤回、开始后中止` 等状态变化，而不是身体部位清单。

### 6. 控制时长

- 4–6 秒：刺激 → 第一次变化 → 结束状态。
- 7–10 秒：基线 → 刺激 → 处理 → 行动/选择 → 结束状态。
- 11–15 秒：可增加一次失败恢复、短对白、听者反应或短促释放。

若信息超出预算，删减次要 beat 或拆镜；不要承诺镜内精确到秒的微动作。

### 7. 渲染模型版本

- Seedance：连续因果 prose，使用相对时序，突出单一表演弧。
- Kling：把 UI/API 配置与正文分开；Custom Multi-Shot 每镜一个戏剧任务并给逐镜时长。
- Kling Standard/Omni 的演员 Cut 情绪输出：正文使用带时间范围的分段框架。分段数量、边界与状态标题按本次表演动态生成；标题直接写 `【0–1.4s｜状态】`，不得在时间前添加“约”。正文同时声明时间范围仅作节奏参考，跨段动作必须连续，不得在边界停顿、重置或重新起势。Motion Control 不使用该框架驱动动作。

模型适配只改变表达包装，不改变角色的核心行动逻辑。

### 8. 质量检查与定向护栏

按 `references/quality-gates.md` 检查。护栏只针对当前已知或高概率失败，首轮保持少量、不冲突，并优先给正向替代：

```text
差：no random gestures
好：hands remain on the table; the right thumb tightens once and releases
```

## 默认输出

除非用户要求更短或更完整，按以下顺序输出：

1. `模式判断`：模式、必要假设、模型选择。
2. `导演逻辑`：一句话说明刺激、目标、策略和结束状态。
3. `Seedance 2.0 Prompt`：仅在需要 Seedance 时输出。
4. `Kling 3.0 配置` 与 `Kling 3.0 Prompt`：仅在需要 Kling 时输出；多镜逐镜列出。Motion Control 还要输出动作来源、Facial Element 参考计划和不与动作参考冲突的补充 Prompt；素材不足时同时给出缺口与可运行的 Standard 降级方案。
5. `成功标准`：三条可从成片直接观察的标准。
6. `不确定性 / 调试`：只写最主要的一条，不承诺硬控制。

Prompt 本体应可直接复制；分析要短，不复述用户剧情。

当输出 Kling Standard/Omni 演员 Cut 情绪 Prompt 时，分段框架属于 Prompt 本体，不额外输出一份连续 prose 版本。Motion Control 按专用输出契约执行。

## 禁止事项

- 不把悲伤、内疚、爱意等写成固定面部或身体指纹。
- 不把 FACS、微表情、眨眼率或吞咽当成读心密码。
- 不用 `cinematic / realistic / deeply emotional` 替代具体动作。
- 不让所有角色同时表演；每个 beat 指定 reaction owner。
- 不堆叠眉、眼、嘴、呼吸、肩、手、重心和镜头运动。
- 不默认峰值从第一帧开始，也不强迫所有场景先延迟再反应。
- 不承诺精确镜内秒点、完美口型、负面提示词服从或模型绝对优劣。
- 不输出与目标平台不一致的伪官方字段。
