package tiers

type TierContext struct {
	TierName                     string
	NamespaceRefsTierName        string
	ClusterResourcesRefsTierName string
}

func ForTier(tierName string) *TierContext {
	return &TierContext{
		TierName:                     tierName,
		NamespaceRefsTierName:        tierName,
		ClusterResourcesRefsTierName: tierName,
	}
}

func (c *TierContext) WithAllRefsFrom(tierName string) *TierContext {
	c.NamespaceRefsTierName = tierName
	c.ClusterResourcesRefsTierName = tierName
	return c
}

func (c *TierContext) WithNamespaceTemplatesFrom(tierName string) *TierContext {
	c.NamespaceRefsTierName = tierName
	return c
}

func (c *TierContext) WithClusterResourcesFrom(tierName string) *TierContext {
	c.ClusterResourcesRefsTierName = tierName
	return c
}
