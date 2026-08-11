# AI Character Performance Director

将角色意图、关系、刺激、情绪、对白、时长与镜头限制，转换为可观察、可拍摄、非模板化的 AI 视频表演 Prompt。

支持 Seedance 2.0 与 Kling 3.0，覆盖演员 Cut、剧情表演、对白听戏、情绪高潮、复杂动作及失败修复。

## 核心原则

- 不把情绪映射成固定表情或身体指纹。
- 先确定角色此刻的目标、刺激与行动策略，再设计可观察动作。
- 使用可裁剪 Beat Graph，不强迫所有表演遵循固定时间模板。
- 每个 beat 优先安排一个主要表演任务，减少动作竞争。
- 区分官方能力、用户实测与待验证实验，不把推断写成模型保证。

## 表演模式

| 模式 | 适用场景 | 重点 |
|---|---|---|
| `actor_cut` | 镜头主要对着演员，表演本身就是内容 | 眼神、面部、声音、手部、姿态及情绪弧 |
| `narrative` | 人物行动实际推动剧情或改变关系、信息、距离、物件与决定 | 事件、反应拥有者、行动选择、对方反应与剧情后果 |

Skill 会自动判断模式；用户也可以明确指定“演员 Cut”或“剧情表演”。

## 模型与工作流

- Seedance 2.0：输出连续、自然的因果文本与相对时序。
- Kling 3.0 Standard：适合单镜、可串行描述的表演。
- Kling 3.0 Omni：用于角色、声音、多参考或跨镜连续性需求。
- Kling Custom Multi-Shot：按“每镜一个戏剧任务”拆分。
- Kling Motion Control：动作由上传视频或 Motion Library 提供，正文不重复编排动作时间线。

Kling Standard/Omni 的演员 Cut 情绪 Prompt 使用动态时间分段；分段只负责节奏引导，不承诺镜内精确关键帧，也不会在时间前添加“约”。

## 使用示例

```text
调用 ai-character-performance-director：
Kling 3.0 Standard，8 秒，演员 Cut，单人面对镜头，无台词。
表演久别重逢，情绪充分但不过度；人物始终原地，只允许面部、肩部和双臂动作。
```

默认输出包括：

1. 模式判断与必要假设；
2. 一句话导演逻辑；
3. 对应模型的可运行 Prompt；
4. 三条可观察成功标准；
5. 一条主要不确定性或调试建议。

## 已验证的 Kling 原地表演修复

针对 Kling 3.0 Standard、8 秒、单人中近景演员 Cut 出现“人物走近后又退回”的问题，已通过用户生成验证的文本策略是：

- 开头定义人物站定、双脚持续承重、人物与镜头距离不变；
- 主要动作限制在眼神、面部、肩部和双臂；
- 原地高潮使用横向局部动作；
- 删除前倾、朝镜头靠近、迎接/拥抱及全身返回任务。

该结论只适用于已验证条件，不扩写成 Kling Standard 对所有原地动作的保证。完整回归样例见 [`tests/fixtures/kling3-standard-stationary-reunion.verified.md`](tests/fixtures/kling3-standard-stationary-reunion.verified.md)。

## 证据门禁

模型能力、失败原因和稳定修复分为四种状态：

- `official`：模型厂商官方资料明确支持；
- `user_verified`：用户已通过实际生成确认；
- `experimental`：仍需成片验证；
- `rejected`：已被实测否决或与官方资料冲突。

来源、适用范围与禁止扩写边界见 [`references/evidence-ledger.md`](references/evidence-ledger.md)。

## 文件结构

```text
SKILL.md                 核心路由、输入输出契约与工作流
agents/openai.yaml       Skill UI 元数据
adapters/                Seedance、Kling 与适配器契约
references/              表演内核、模式规则、对白、高潮、证据与质量门禁
tests/                   验收案例、回归样例与静态校验
```

## 验证

```bash
./tests/validate.sh
```

验证覆盖 Skill 文件结构、输出契约、Kling 动态分段、复杂动作路由、证据登记及已验证的原地表演回归样例。
