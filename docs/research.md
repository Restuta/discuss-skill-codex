# Research

This project is not based on the claim that "more models always means better answers."

The actual claim is smaller:

1. multiple reasoning paths can help
2. structured disagreement can help
3. you still need hard stop rules, clear roles, and concise synthesis

## Useful Primary Sources

### Multi-agent debate

Du et al. show that multi-agent debate can improve factuality and reasoning, including reducing hallucination-like failure modes.

Source:

1. [Improving Factuality and Reasoning in Language Models through Multiagent Debate](https://arxiv.org/abs/2305.14325)

### Self-consistency

Wang et al. show that sampling multiple reasoning paths and choosing the most consistent answer can improve reasoning performance.

Source:

1. [Self-Consistency Improves Chain of Thought Reasoning in Language Models](https://arxiv.org/abs/2203.11171)

### Adaptive debate

Eo et al. show that debate does not need to happen on every problem, and adaptive strategies can retain quality while reducing cost.

Source:

1. [Debate Only When Necessary: Adaptive Multiagent Collaboration for Efficient LLM Reasoning](https://arxiv.org/abs/2504.05047)

## Practical Takeaway

What matters most for `discuss-skill` is not "more agents."

What matters is:

1. one shared source of truth
2. disciplined turn structure
3. explicit contention points
4. concise consensus output
5. clear stop conditions
