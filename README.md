# AI Character Performance Director

将角色意图、关系、刺激、情绪、对白、时长与镜头限制，转换为有戏剧行动、可观察、可拍摄、非模板化的 AI 视频表演 Prompt。

支持 Seedance 2.0 与 Kling 3.0，覆盖演员 Cut、剧情表演、对白听戏、情绪高潮、复杂动作及失败修复。

当前版本：`1.1.0`；version code：`10100`。版本号采用 SemVer，version code 按 `major × 10000 + minor × 100 + patch` 计算，机器可读值见 [`VERSION`](VERSION)。

## 核心原则

- 不把情绪映射成固定表情或身体指纹。
- 先确定角色正在影响谁、希望对方改变什么、采用什么 tactic，再设计可观察动作。
- 情绪由行动成功、受阻或策略变化产生，不直接决定身体动作。
- 同一需求内部比较不同影响策略，而不是替换表情与强度词。
- 使用可裁剪 Beat Graph，不强迫所有表演遵循固定时间模板。
- 每个 beat 优先安排一个主要表演任务，减少动作竞争。
- 区分官方能力、用户实测与待验证实验，不把推断写成模型保证。

## 演技提升流程

```text
风格定位
→ 规定情境与行动对象
→ WANT、阻力与 tactic
→ 反馈驱动的逐刻变化
→ 镜头可见行为
→ 模型可执行性压缩
→ Prompt
```

分析深度会随任务自适应：4–6 秒简单演员 Cut 只保留最低必要逻辑；对白、冲突和复杂关系才增加 stakes、潜台词或多次策略变化。内部分析不会堆入最终 Prompt。

风格优先服从用户明确要求和参考素材，其次使用场景与景别的可观察线索；仍无依据时只作最小假设，不默认写实或克制。

用户提供成片或多个 Take 时，Skill 才加载成片反馈规则，区分需求偏差、模型伪影、表演策略和呈现干扰，并只修正最先失效的 Beat。

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
VERSION                  version name 与递增 version code
agents/openai.yaml       Skill UI 元数据
adapters/                Seedance、Kling 与适配器契约
references/              演技提升、表演内核、成片反馈、模式规则、证据与质量门禁
tests/                   验收案例、回归样例与静态校验
```

## 验证

```bash
./tests/validate.sh
```

验证覆盖版本元数据、Skill 文件结构、演技提升路由、成片反馈边界、时长契约、行为回归样例、Kling 动态分段、复杂动作路由、证据登记及已验证的原地表演回归样例。行为回归用于验证 Skill 决策，不等同于 Kling 成片或用户生成验证。
