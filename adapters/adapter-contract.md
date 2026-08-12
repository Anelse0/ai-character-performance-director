# 模型适配器契约

新增模型只修改渲染层，不改变表演语义对象、模式判断或 Beat Graph。

每个适配器必须声明：

```yaml
adapter_id:
supported_models:
verified_scope:
configuration_surface:
single_shot_rendering:
multi_shot_rendering:
dialogue_binding:
reference_binding:
interaction_rendering:
entity_constraint_boundary:
timing_boundary:
negative_constraint_boundary:
known_failures:
output_shape:
```

## 必须遵守

- 区分官方配置项、作者规划概念和普通 Prompt 文本。
- 只写已知入口支持的配置；入口不明时提供概念选择，不伪造字段名。
- 保留 acting core 的 trigger、WANT、策略、主变化和 end state。
- 继承 acting core 已确定的 `render_mode`、实体契约、首帧门禁与物理冲突结论；适配器只能改变表达包装，不能把 `incompatible` 改写成可运行 Prompt。
- 声明隐藏对象、实体排除、短暂接触暗示和物体交换的渲染方式及能力边界。
- 允许适配器调整文本顺序、镜头包装和约束表达，不得重写角色动机。
- 标明镜内时序、口型、身份、参考绑定和负面约束的证据边界。
- 给出单镜与多镜的选择规则及输出格式。

## 适配器验收

- 同一语义对象经不同适配器渲染后，剧情行动和 ending 一致。
- 不出现另一平台专属语法。
- 输出可以直接复制到对应正文输入区，配置部分可以被用户单独设置。
- 新模型无法支持某项要求时，明确降级或拆分，不用提示词伪装成硬能力。
- Seedance、Kling 或未来模型对同一交互语义必须保持相同的直接动作、实验性暗示、邀请等待或冲突结论；只改变正文组织方式。
