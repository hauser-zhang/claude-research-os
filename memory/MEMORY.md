# Research OS — L2 Memory Index

> L2 跨项目 memory。记录跨项目通用的 feedback——协作风格、研究纪律、写作规范、工具使用坑点。
>
> 私有内容的分层约定：
> - `user_*.md`（个人档案） — `.gitignore` 排除，只在本地有效
> - `private_*.md`（项目内隐私笔记） — `.gitignore` 排除
> - `feedback_*.md`（跨项目可复用的协作规则） — 入仓，但所有例子中的专有名词用通用占位符

## Feedback — 协作与会话边界
- [Collaboration Mode](feedback_collaboration_mode.md) — 完整 Case 分析 + 外部平台镜像交付，用于毕业论文 / 组会素材
- [Session Boundary](feedback_session_boundary.md) — 每 session 只负责自己任务，旧 plan 不自动执行（铁律）
- [Long Task Monitoring](feedback_long_task_monitoring.md) — 长任务后台 sub-agent 轮询，主 agent 空闲
- [Research OS Architecture v1](feedback_research_os_architecture.md) — 2026-04-20 三层架构升级决策（跨项目铁律）

## Feedback — 研究深度与写作
- [Research Depth](feedback_research_depth.md) — 调研必须到可复现级（完整数据流、参数、损失公式、消融数字）
- [Documentation Standards](feedback_documentation.md) — 绝对路径、Visual-first、Brainstorm 存决策非对话流水
- [Writing Material Structure](feedback_writing_material.md) — 每 Panel 五层结构 + Analysis metadata + panel-level audit
- [README Requirement](feedback_readme_requirement.md) — 代码目录必须同时有 README.md（人读）+ CLAUDE.md（Claude 读）

## Feedback — 代码风格与实验纪律
- [Code Style](feedback_code_style.md) — 保留原文件、讨论优先、.sh 脚本、不覆盖结果
- [Backward Compatibility](feedback_backward_compat.md) — 代码改动不破坏旧 YAML / checkpoint / 推理路径
- [Never Modify Data Files](feedback_never_modify_data_files.md) — 改代码适配数据格式，不改数据/checkpoint/结果
- [Experiment Tracking](feedback_experiment_tracking.md) — Table-driven 外部镜像、GPU 优先级、不覆盖 baseline
- [Figure Verification](feedback_figure_verification.md) — 出图后必须视觉核查 colorbar/layout/labels
- [Short Pipeline Rerun](feedback_short_pipeline_rerun.md) — <10min pipeline 直接清旧输出重跑，只清当前任务目录

## Feedback — Git 与 Skill 设计
- [Git Commit Conventions](feedback_git_commit.md) — 每 session commit+push，按功能分，chore 仅限维护
- [Skill Design](feedback_skill_design.md) — plan 放 skill 文件夹，references 吸收易变状态，scripts 仅限自动化

## Feedback — 外部协作平台与工具
- [External Platform Doc Linkage](feedback_feishu_doc_linkage.md) — 子页面变更必须同步父页面 + 主文档日志（铁律）
- [Lark Markdown Pitfalls](feedback_lark_markdown_pitfalls.md) — 双引号/多行 blockquote 会截断内容，规避
- [Lark Media Insert Path](feedback_lark_media_insert_path.md) — +media-insert 只接相对路径，先 cd 文件目录
- [Figure to External Platform Pipeline](feedback_figure_feishu_pipeline.md) — SVG/PDF→PNG 用 Ghostscript gs，scp 逐文件列出
- [Opus Token Guard](feedback_opus_token_guard.md) — Opus 下大规模外部平台写入先报清单，禁止自主 overwrite
- [MSYS Path Conversion](feedback_msys_pathconv.md) — Windows Git Bash 调外部 API 需 MSYS_NO_PATHCONV=1
- [SSH File Patching](feedback_ssh_file_patching.md) — heredoc 内 Python 单引号炸 EOF，用 cp+patch
