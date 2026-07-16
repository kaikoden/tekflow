enum TipCategory { dailyHabits, bigPurchases, savings, investments, mindset }

class FinanceTip {
  final String id;
  final String text;
  final TipCategory category;
  final String emoji;

  const FinanceTip({
    required this.id,
    required this.text,
    required this.category,
    required this.emoji,
  });
}

const List<FinanceTip> allTips = [
  // ── Daily Habits ──────────────────────────────────────────────────────────
  FinanceTip(
    id: '1',
    text: 'Mag-track ng bawat piso sa loob ng 30 araw — ang awareness lang ay nakakabawas ng 20% sa gastos.',
    category: TipCategory.dailyHabits,
    emoji: '📊',
  ),
  FinanceTip(
    id: '2',
    text: 'Gamitin ang 24-hour rule bago bumili ng kahit anong hindi kailangan na lagpas ₱500.',
    category: TipCategory.dailyHabits,
    emoji: '⏰',
  ),
  FinanceTip(
    id: '3',
    text: 'Magbaon ng lunch 3x a week — kahit ₱100/day lang yan, ₱1,200/month na ang natipid mo.',
    category: TipCategory.dailyHabits,
    emoji: '🍱',
  ),
  FinanceTip(
    id: '4',
    text: 'I-cancel ang mga subscriptions na hindi mo nagamit sa loob ng 30 araw.',
    category: TipCategory.dailyHabits,
    emoji: '📱',
  ),
  FinanceTip(
    id: '5',
    text: 'Huwag mamili ng grocery kung gutom — nadadagdagan ng 25–40% ang iyong cart.',
    category: TipCategory.dailyHabits,
    emoji: '🛒',
  ),
  FinanceTip(
    id: '6',
    text: 'Magkape sa bahay 4x a week — nakakatipid ka ng ₱1,500–₱3,000 kada buwan.',
    category: TipCategory.dailyHabits,
    emoji: '☕',
  ),
  FinanceTip(
    id: '7',
    text: 'Gumamit ng GCash o PayMaya para makita mo ang bawat gastos — visible ang hidden spending.',
    category: TipCategory.dailyHabits,
    emoji: '💳',
  ),
  FinanceTip(
    id: '8',
    text: 'Gumawa ng weekly 10-minute money review — alamin kung saan napupunta ang pera mo.',
    category: TipCategory.dailyHabits,
    emoji: '🔍',
  ),
  FinanceTip(
    id: '9',
    text: 'Mag-unsubscribe sa marketing emails — out of sight, out of mind, out of cart.',
    category: TipCategory.dailyHabits,
    emoji: '📧',
  ),
  FinanceTip(
    id: '10',
    text: 'Magluto sa bahay 5x a week — nakakatipid ka ng ₱3,000–₱8,000 kada buwan.',
    category: TipCategory.dailyHabits,
    emoji: '🍳',
  ),

  // ── Big Purchases ─────────────────────────────────────────────────────────
  FinanceTip(
    id: '11',
    text: 'Bago bumili ng mahal, tanungin ang sarili: "Kailangan ko ba ito sa susunod na 90 araw?" Karamihan ay "hindi".',
    category: TipCategory.bigPurchases,
    emoji: '🤔',
  ),
  FinanceTip(
    id: '12',
    text: 'Bumili ng electronics na 2–3 generations behind — 60–70% mas mura, 90% ng function.',
    category: TipCategory.bigPurchases,
    emoji: '📱',
  ),
  FinanceTip(
    id: '13',
    text: 'Huwag bumili ng sasakyan na lagpas sa 15% ng annual income mo — mabilis ang depreciation.',
    category: TipCategory.bigPurchases,
    emoji: '🚗',
  ),
  FinanceTip(
    id: '14',
    text: 'Gumamit ng price-tracking apps (Shopee, Lazada) bago bumili ng lagpas ₱1,000.',
    category: TipCategory.bigPurchases,
    emoji: '📉',
  ),
  FinanceTip(
    id: '15',
    text: 'Bumili ng refurbished para sa appliances — 30–50% off na may warranty pa.',
    category: TipCategory.bigPurchases,
    emoji: '🔄',
  ),
  FinanceTip(
    id: '16',
    text: 'Makipag-negotiate sa lahat — services, rent, insurance, internet. Walang mawawala kung magtanong.',
    category: TipCategory.bigPurchases,
    emoji: '🤝',
  ),
  FinanceTip(
    id: '17',
    text: 'Iwasan ang "0% interest" na installment — madalas inflated ang presyo ng produkto.',
    category: TipCategory.bigPurchases,
    emoji: '⚠️',
  ),
  FinanceTip(
    id: '18',
    text: 'I-compare ang cost-per-use, hindi ang presyo. ₱3,000 na ginamit isang beses ay mas mahal pa sa ₱15,000 na ginagamit araw-araw.',
    category: TipCategory.bigPurchases,
    emoji: '💡',
  ),

  // ── Savings ───────────────────────────────────────────────────────────────
  FinanceTip(
    id: '19',
    text: 'Bayaran mo muna ang sarili mo — mag-automate ng 20% savings bago gumastos.',
    category: TipCategory.savings,
    emoji: '💰',
  ),
  FinanceTip(
    id: '20',
    text: 'Mag-ipon ng 3–6 months na emergency fund bago mag-invest. Seguridad ang pundasyon.',
    category: TipCategory.savings,
    emoji: '🛡️',
  ),
  FinanceTip(
    id: '21',
    text: 'Ang 50-30-20 rule: 50% needs, 30% wants, 20% savings/debt. I-adjust sa iyong sitwasyon.',
    category: TipCategory.savings,
    emoji: '📏',
  ),
  FinanceTip(
    id: '22',
    text: 'Tuwing may salary increase, subukang i-save ang 50% ng dagdag — huwag agad i-upgrade ang lifestyle.',
    category: TipCategory.savings,
    emoji: '📈',
  ),
  FinanceTip(
    id: '23',
    text: 'I-automate ang savings sa araw ng sweldo — ang willpower ay limitado, ang sistema ay hindi.',
    category: TipCategory.savings,
    emoji: '🤖',
  ),
  FinanceTip(
    id: '24',
    text: 'Ilagay ang savings sa ibang account na walang debit card — nakakabawas ng impulse withdrawal.',
    category: TipCategory.savings,
    emoji: '🔒',
  ),
  FinanceTip(
    id: '25',
    text: 'Ang 10% savings rate ay survival. 20% ay comfort. 40%+ ay kalayaan.',
    category: TipCategory.savings,
    emoji: '🎯',
  ),
  FinanceTip(
    id: '26',
    text: 'I-round up ang bawat transaction sa susunod na ₱100 sa iyong mental accounting — ang buffer ay dumadagdag.',
    category: TipCategory.savings,
    emoji: '⬆️',
  ),

  // ── Investments ───────────────────────────────────────────────────────────
  FinanceTip(
    id: '27',
    text: 'Mas mahalaga ang oras sa merkado kaysa sa pag-timing ng merkado — 95% ng mga nagte-timing ay natatalo.',
    category: TipCategory.investments,
    emoji: '⏳',
  ),
  FinanceTip(
    id: '28',
    text: 'Magsimula ng SIP kahit ₱500/month — ang compounding sa loob ng 20 taon ay mas malakas kaysa sa "hot tip".',
    category: TipCategory.investments,
    emoji: '🌱',
  ),
  FinanceTip(
    id: '29',
    text: 'Ang index funds ay mas mahusay kaysa sa 80% ng actively managed funds sa loob ng 10+ taon. Panatilihing simple.',
    category: TipCategory.investments,
    emoji: '📊',
  ),
  FinanceTip(
    id: '30',
    text: 'Mag-invest sa sarili mo muna — ang skills na nagpapataas ng income ay may pinakamataas na ROI.',
    category: TipCategory.investments,
    emoji: '🎓',
  ),
  FinanceTip(
    id: '31',
    text: 'I-maximize ang Pag-IBIG MP2 — mas mataas ang dividend kaysa sa regular na savings account.',
    category: TipCategory.investments,
    emoji: '🏛️',
  ),
  FinanceTip(
    id: '32',
    text: 'Huwag ilagay ang higit sa 5% ng portfolio mo sa iisang stock. Diversification ay libreng insurance.',
    category: TipCategory.investments,
    emoji: '🧺',
  ),
  FinanceTip(
    id: '33',
    text: 'I-rebalance ang portfolio mo isang beses sa isang taon — huwag sa bawat market dip.',
    category: TipCategory.investments,
    emoji: '⚖️',
  ),
  FinanceTip(
    id: '34',
    text: 'Ang emergency fund ay ilagay sa digital banks (SeaBank, Maya, CIMB) na may mataas na interest, hindi sa savings account o equities.',
    category: TipCategory.investments,
    emoji: '💧',
  ),
  FinanceTip(
    id: '35',
    text: 'Ang real estate ay hindi liquid — huwag bilangin ang bahay mo bilang investment kung hindi mo naman ito ibebenta.',
    category: TipCategory.investments,
    emoji: '🏠',
  ),

  // ── Mindset ───────────────────────────────────────────────────────────────
  FinanceTip(
    id: '36',
    text: 'Ang yaman ay hindi income, ito ay kung ano ang naiiwan sa iyo. Ang ₱100K/month na gumagastos ay mas mahirap kaysa sa ₱50K/month na nag-iipon.',
    category: TipCategory.mindset,
    emoji: '🧠',
  ),
  FinanceTip(
    id: '37',
    text: 'Ang lifestyle inflation ay ang silent killer — ang bawat upgrade ay nagkakahalaga sa iyo ng taon ng kalayaan.',
    category: TipCategory.mindset,
    emoji: '🚀',
  ),
  FinanceTip(
    id: '38',
    text: 'Ang pag-compare ng sarili sa iba ay nakakalason — iba-iba ang starting line ng bawat isa.',
    category: TipCategory.mindset,
    emoji: '🎭',
  ),
  FinanceTip(
    id: '39',
    text: 'Ang pagiging matipid ay hindi deprivation — ito ay pagpili sa kung ano ang tunay na mahalaga sa iyo.',
    category: TipCategory.mindset,
    emoji: '🎯',
  ),
  FinanceTip(
    id: '40',
    text: 'Ang financial freedom ay pagbili ng oras, hindi ng mga bagay. Ang oras ay ang tanging non-renewable resource.',
    category: TipCategory.mindset,
    emoji: '⏰',
  ),
  FinanceTip(
    id: '41',
    text: 'Ang maliliit na consistent actions ay mas malakas kaysa sa malalaking sporadic actions. ₱100/araw > ₱3,000 isang beses sa isang buwan.',
    category: TipCategory.mindset,
    emoji: '🔁',
  ),
  FinanceTip(
    id: '42',
    text: 'Alamin ang pagkakaiba ng asset (nagdadala ng pera sa iyo) at liability (kumukuha ng pera sa iyo).',
    category: TipCategory.mindset,
    emoji: '📚',
  ),
  FinanceTip(
    id: '43',
    text: 'Ang pinakamahusay na financial decision ay ang manatiling malusog — ang medical costs ay kayang magpawi ng savings.',
    category: TipCategory.mindset,
    emoji: '❤️',
  ),
  FinanceTip(
    id: '44',
    text: 'Ang iyong network ay nakakaapekto sa iyong net worth — palibutan ang sarili ng mga taong financially disciplined.',
    category: TipCategory.mindset,
    emoji: '🤝',
  ),
  FinanceTip(
    id: '45',
    text: 'Ang budget ay hindi restriction — ito ay permission na gumastos ng walang guilt sa mga na-prioritize mo.',
    category: TipCategory.mindset,
    emoji: '✅',
  ),
  FinanceTip(
    id: '46',
    text: 'Ang sikreto sa pagyaman ay boring: gumastos ng mas mababa sa kinikita, i-invest ang difference, ulitin.',
    category: TipCategory.mindset,
    emoji: '🔑',
  ),
  FinanceTip(
    id: '47',
    text: 'Ang bawat financial mistake ay tuition — pag-aralan, matuto, magpatuloy. Ang guilt ay mas mahal.',
    category: TipCategory.mindset,
    emoji: '🎓',
  ),
  FinanceTip(
    id: '48',
    text: 'Ang FOMO investing — bumili dahil lahat ay bumibili — ay kung paano natatalo ang karamihan ng retail investors.',
    category: TipCategory.mindset,
    emoji: '😰',
  ),
  FinanceTip(
    id: '49',
    text: 'Magbasa ng isang personal finance book sa isang taon — ang knowledge ay nagco-compound tulad ng pera.',
    category: TipCategory.mindset,
    emoji: '📖',
  ),
  FinanceTip(
    id: '50',
    text: 'Ang tunay na luxury ay ang gumising ng walang financial anxiety — hindi ang pagmamay-ari ng pinakamahal na bagay.',
    category: TipCategory.mindset,
    emoji: '🌅',
  ),
];