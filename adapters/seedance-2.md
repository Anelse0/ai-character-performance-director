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

## 单镜渲染

- 默认使用 `one continuous [duration] [shot size]`。
- 以 `when / at first / after a beat / only then / end with` 建立相对顺序。
- 一个镜头只解决一个主要表演问题。
- 微表演优先使用稳定中近景或特写。
- 镜头运动若非必要就删除；必须使用时只保留一个，并让它服务状态变化。

正文形态示意：

```text
One continuous [duration] [framing]. [Character and stable starting state].
When [specific trigger], [orientation or processing]. After a beat, [primary change]
and [optional visible support]. [Direct action or control/redirect]. Only then,
[short dialogue or threshold if needed]. End with [residue or intentional threshold cut].
[Two or three targeted positive guardrails].
```

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
[仅列素材职责、时长、画幅、音频等需要用户在入口设置的内容]

### Seedance 2.0 Prompt
```text
[连续、可复制正文]
```
````
