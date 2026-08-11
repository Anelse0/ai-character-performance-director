# 证据门禁与来源登记

## 晋升规则

本规则由用户于 2026-08-11 明确要求：写入 skill 的模型能力、失败原因与稳定修复，必须有正确来源或经过用户明确生成验证。

- `official`：模型厂商官方文档明确支持，可写成平台事实；保留适用版本和边界。
- `user_verified`：用户报告了实际生成结果；只在相同模型、工作流、输入条件和约束范围内成立。
- `experimental`：只有修复假设，尚无官方依据或用户成片验证；可以作为待验证输出，不能进入稳定规则。
- `rejected`：用户实测无效或与官方资料冲突；不得再次作为默认建议。

新增稳定规则必须引用下列证据编号。推断不得借“工程经验”绕过门禁。

## Kling 官方来源

### [K-I2V-01] 图生视频的主体运动写法

- 状态：`official`
- 来源：[Kling AI Image to Video Guide](https://kling.ai/quickstart/image-to-video-guide)，章节 “Prompt = Subject + Movement, Background + Movement” 与 Tips。
- 发布：2025-11-24；访问：2026-08-11。
- 支持：图生视频的核心写法是主体＋运动状态；官方建议使用简单词语和句式，动作符合物理规律并与输入图像中可能发生的运动相符。
- 边界：该指南没有承诺纯 Prompt 能硬锁人物站位。

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

### [USER-POLICY-01] Skill 证据门禁

- 状态：`user_verified`
- 用户要求日期：2026-08-11。
- 要求：所有新增 Skill 内容必须有正确资讯来源，或经过用户明确验证后再写入；禁止以未经验证的推断充当稳定规则。
