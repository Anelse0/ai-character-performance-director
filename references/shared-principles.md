# 共享原则(权威表述)

本文件收敛在多个 reference 中重复出现的核心规则,作为**权威表述**。其他文件可以在各自语境复述这些规则以保持独立可读,但语义应与本文件一致;发现分歧时以本文件为准。`tests/validate.sh` 对下列关键措辞做存在性检查,防止漂移。

## 1. 设计立场:精密度服务于可诊断,不等于成片服从

本 skill 的细粒度编排(逐 Beat、单一主意图、通道预算、动作签名、Camera Unit)首要目的是让 **Prompt 自洽、失效可定位**:当成片出问题时,能回到具体的 Beat 或 Camera Unit 节点定向修正。它**不承诺成片会逐项服从**这些微观指令。模型对精确微动作、负面提示词、口型、关键帧和实体数量的服从必须经过多次生成验证。

因此:内部精度是为了减少歧义与便于反馈闭环,不是"写得越细,模型越听话"的保证。当精度超出模型可控范围时,优先减少竞争、简化载体或转交动作控制工作流,而不是继续堆叠指令。

## 2. 镜头与演员共用同一执行预算

复杂人物动作配简单镜头关系;复杂空间揭示配单一主体动作。当一方承担明显变化时,另一方改为固定关系、简单跟随或串行。两者各自承担独立变化且无法压缩时,先删除、串行或拆镜,**不能借"同时"强行合并**。

## 3. 每镜只有一个主要运动任务

每个 Camera Unit 只有一个主要运镜;辅助 pan/tilt 只用于维持构图,不承担第二个揭示。航拍、俯拍、POV、手持和 oner 只说明视点/质感/结构,不能替代路径、触发和落幅。

## 4. 不堆叠表演通道

每个 beat 只安排一个主要表演意图。**不堆叠眉、眼、嘴、呼吸、肩、手、重心和镜头运动**。机械联动(同一动作的必要连带)属于同一个 Motion Unit;头、手、表情、重心各自承担独立任务时属于动作并发,必须删减、串行或路由到动作控制工作流。

## 5. 护栏优先正向,而非纯否定

只加入当前场景需要的少量护栏。**纯否定护栏尽可能改写为正向状态变化**:

```text
差:no random gestures
好:hands remain on the table; the right thumb tightens once and releases
```

## 6. 内部标签不伪装成官方字段

`root_motion` 是本 skill 的内部需求标签,不是任何模型的官方字段。同理 `reaction owner / visible sequence / end state / Camera Unit` 等都是创作规划概念,最终应渲染为普通正文或概念配置,不冒充统一 API 字段。

## 7. 证据分级先于稳定规则

写入 skill 的模型能力、失败原因与稳定修复,必须有 official 来源或经用户明确成片验证。分级为 `official / user_approved / user_verified / experimental / rejected`;推断只能作为"待验证实验版本"输出。完整登记见 `references/evidence-ledger.md`。

## 8. 验证覆盖与置信度

已有 `user_verified` 成片证据集中在 Kling 3.0 Standard 单人 `actor_cut`。`environment`(空镜/航拍)与 `narrative` 多镜多人目前只有自测 forward-test,无真实成片验证,应按设计级(experimental)置信度对待,不宣称成片质量已验证。official 能力最后核实日期见 `references/evidence-ledger.md`。
