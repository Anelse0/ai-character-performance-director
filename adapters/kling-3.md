# Kling 3.0 适配器

## 先选择模型与工作流

- `Kling 3.0 Standard`：纯文本/图生、简单身份绑定。
- `Kling 3.0 Omni`：确有独立角色元素、声音绑定、多参考或跨镜连续性需求。
- `single shot`：一条可串行描述的简单动作链。
- `Custom Multi-Shot`：复杂性来自多个镜头任务。
- `Motion Control`：动作来自上传的动作视频或 Motion Library；用于精确路径、次数、节奏或高协调表演，不是 text-only Prompt 能力。

不要只因场景“情绪复杂”就升级 Omni，也不要把 Omni 当成 Motion Control。用户未指定版本且没有参考/声音连续性需求时默认 Standard；工作流按 `references/kling-motion-control.md` 独立判断。

## 配置与正文分离

输出先列用户需要在实际入口选择的配置，再给普通 Prompt 正文。字段名会因 Kling 官方 UI 或合作方 API 而异，因此使用概念名称，不伪造统一 API：

```yaml
model: Standard 3.0 | 3.0 Omni | 3.0 Motion Control
workflow: single shot | Custom Multi-Shot | Motion Control
duration:
audio:
character_or_voice_binding:
reference_role:
motion_source:
facial_element_binding:
orientation:
```

`reaction owner`、`visible sequence`、`end state`、`acting guardrail` 是创作规划概念，不是官方字段。可在分析中使用，但最终应渲染为普通正文。

## Standard/Omni 演员 Cut 情绪 Prompt：强制输出框架

Kling Standard/Omni 的演员 Cut 情绪输出必须使用分段式 Prompt，不另附连续 prose 版本。Motion Control 不使用本框架驱动动作。

- 开头写总时长、稳定单镜、景别与声音状态。
- 明确说明时间范围只用于节奏引导，动作可以自然提前或延后。
- 根据 Beat Graph 动态使用 3–5 段，不固定段数或比例。
- 每段使用具体、连续的时间范围，从 `0` 覆盖到总时长，无空缺和重叠。
- 标题格式为 `【0–1.4s｜正常状态】`；时间前不得添加“约”。
- 阶段标题按场景生成，不强制使用“正常—浮现—高潮—回落—恢复”五段。
- 前一段动作可跨过时间边界自然完成；后一段必须承接，不重新起势。
- 简单的 8 秒表演通常使用 3–4 段；只有动作或情绪责任确实不同才拆到 5 段。
- Prompt 末尾集中输出少量定向护栏。

格式骨架：

```text
[总时长]稳定单镜[景别]，[有台词/无台词]。时间范围仅作为节奏参考，动作可以根据表演自然提前或延后；所有变化连续衔接，不在分段边界停顿、重置或重新起势。

【0–[t1]s｜[动态状态名]】
[起始状态与 eyeline]

【[t1]–[t2]s｜[动态状态名]】
[刺激与第一次变化，承接起始状态]

【[t2]–[t3]s｜[动态状态名]】
[主要行动、选择或短高潮，不重新起势]

【[t3]–[总时长]s｜[动态状态名]】
[回落、残留、恢复或阈值切断]

[身份、人数、动作次数、连续性与伪影护栏]
```

`t1/t2/t3` 只是说明动态边界的内部占位符，最终 Prompt 必须替换为具体数字。

## Standard 单镜

正文按以下逻辑组织：

```text
[duration and framing, named character].
When [trigger], [orientation/process]. Then [primary visible change].
[one supporting cue]. [action/control/choice].
[Name], [delivery after action]: "short line."
End with [residue]. [bounded positive guardrails].
```

- 明确一个 reaction owner。
- 动作按可见时间顺序书写。
- 给动作次数和方向；避免抽象情绪堆叠。
- 遇到跑、跳、转身或复合手势时，按 Motion Unit 写准备、主动作和收势，并补充必要的速度、方向、接触/支撑与镜头关系。
- Standard 中每个 beat 只保留一个主要表演意图；不同身体区域承担独立任务时先删减或串行，不能把多个任务都塞进“同时”。
- 对镜表演若伴随转头或身体运动，写“静止时建立对视—运动时眼神自然调整—回正/落稳后重新对镜”，不要写“眼珠全程固定”或用“始终直视前方”制造锁眼冲突。
- 台词前先动作，台词后嘴部停止发音。
- 单镜内只保留一个主表演弧。
- 若单镜属于演员 Cut 情绪表演，使用上一节的强制分段框架；其他 Standard 单镜仍可使用连续正文。

## Custom Multi-Shot

每个 shot 单独提供 `duration + prompt/content`，总时长与平台限制一致。合作方入口可能在 customize 模式忽略主 Prompt，因此不要假设一个总 Prompt 能替代逐镜内容。

规划规则：

- 每镜一个戏剧任务；
- 一个屏幕内 speaker 或一个 reaction owner；
- 逐镜时长用于镜头段落，不承诺镜内微动作精确卡秒；
- 上一镜 residue 写入下一镜 baseline；
- 正反打保持 eyeline、物件、位置和未完句连续。

输出形态：

````markdown
### Kling 3.0 配置
- 模型：...
- 模式：Custom Multi-Shot
- 总时长：...
- 角色/声音绑定：...

### Shot 1 — [duration]
```text
[该镜可直接填入 prompt/content 的正文]
```

### Shot 2 — [duration]
```text
[承接上一镜 residue 的正文]
```
````

镜头数量按实际入口支持范围控制。若入口不明，提醒用户核对字段和镜头上限，不给虚构参数名。

## Motion Control

Motion Control 由动作视频或 Motion Library 提供人物动作与表情过程。正文 Prompt 只补充不与动作参考冲突的信息，不再用演员 Cut 时间分段重复编排动作。

输出必须包含四部分：

### 1. 概念配置

```yaml
model: Kling VIDEO 3.0 Motion Control
workflow: Motion Control
motion_source: uploaded video | Motion Library
character_image:
facial_element_binding: required | recommended | unnecessary
orientation:
audio:
```

这些是用户需要确认的概念配置，不伪装成固定 API 字段。使用 Facial Element Binding 时说明当前官方入口要求人物朝向匹配动作视频；若实际 UI 改变，以当前入口为准。

### 2. 动作参考编排

把想要的动作写成供拍摄/选择动作参考使用的 Motion Unit，而不是放入最终补充 Prompt：

```text
[起始姿态] → [准备] → [主动作路径、次数、速度] → [接触/落地/收势] → [表情或对镜结束状态]
```

需要指定时长时，让动作参考本身覆盖目标表演长度；不要宣称正文里的时间段可以覆盖动作参考的节奏。

### 3. Facial Element 参考计划

按 `references/kling-motion-control.md` 列出正脸、对应侧脸、目标表情或脸部视频。明确动作参考、角色图与 Facial Element 各自职责，不把 Facial Element 当成服装、发型、妆容或道具锁定。

### 4. 补充 Prompt

只写动作参考没有负责的信息，例如：

```text
[人物与场景外观]。[稳定单镜/允许的镜头关系]。[环境与背景保持状态]。
保持动作参考中的连续表演和结束姿态；人物身份清晰稳定。
```

不要在补充 Prompt 中再次规定另一套头、手、身体或表情顺序。若必须强调一个结果，只写与动作参考一致的落点或镜头可读性。

### 素材不足时

若用户没有上传动作视频且未选 Motion Library：

1. 明确 Motion Control 尚不可直接运行；
2. 给出需要录制/选择的动作参考编排；
3. 若用户接受近似生成，另给删减、串行后的 Standard Prompt；
4. 不把 Standard 降级版描述成能够精确复现动作。

## 对白与听戏

- 固定角色名，speaker、line、delivery 相邻。
- 多人对白优先拆 reaction shots，防止所有角色同时动嘴。
- 画外打断明确来源；屏幕内听者闭口但仍可进行一次非语言反应。
- 需要固定角色声音时使用入口的 character/voice binding，而不是仅靠正文反复描述音色。

## 正向静止

Kling 可能给出比需求更大的身体动作时，减少动作任务并写清什么保持不变、什么只变化一次：

```text
body remains still; only the gaze shifts once
hands stay beside the cup; the right thumb tightens once and releases
```

不要用五条 `no` 约束全身。

## 不得宣称

- Custom Multi-Shot 的逐镜时长等于镜内微表情关键帧控制；
- Omni 的参考一致性等于精确表演驱动；
- Motion Control 可以在没有动作视频或 Motion Library 时仅凭文字运行；
- 时间分段正文可以覆盖或修正动作参考的精确节奏；
- 长对白口型必然稳定；
- 表演类 Negative Prompt 稳定服从；
- Kling 必然更外放、更适合身体或更适合所有对白。
