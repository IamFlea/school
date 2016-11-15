/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package diploidga;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Stroke;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.JTabbedPane;
import javax.swing.event.ChangeEvent;
import javax.swing.text.DefaultCaret;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.LegendItem;
import org.jfree.chart.LegendItemSource;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.AbstractRenderer;
import org.jfree.chart.renderer.xy.DefaultXYItemRenderer;
import org.jfree.chart.renderer.xy.DeviationRenderer;
import org.jfree.chart.renderer.xy.XYAreaRenderer;
import org.jfree.chart.renderer.xy.XYDifferenceRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

/**
 *
 * @author Flea
 */
public class MainForm extends javax.swing.JFrame implements SendMsg{
    public static Random rand; 
    static int maxGenerations;
    static int changeEnviromentGenerations;
    static double changeEnviromentProbability;
    static int changeEnviromentType;
    static int cardinality;
    static int chromosomeLength;
    static int population;
    static int offsprings;
    static TypSelekce selectTypeParent;
    static TypSelekce selectTypePopulation;
    static TypFitness fitnessType;
    static double probabilityMutation;
    static double probabilityCrossover;
    static int crossoverPoints;
    static public String log = "";
    static public String strGAType;
    static boolean strategy1plus1;
    
    static Color grid = new Color(0,0,0,16);
    List<Problem> problems; // problem officer??
    /**
     * Creates new form MainForm
     */
    public MainForm() {
        initComponents();
        problems = new ArrayList<>();
        rand = new Random();
        jProgressBar1.setStringPainted(true);
        DefaultCaret c = (DefaultCaret) textovyVystup.getCaret();
        c.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);
        
    }
    public void updateChart(Problem p){
        JFreeChart chart = p.chart.getChart();
        chart.setTitle("Závislost četnosti změny prostředí na fitness v "+p.sliderVal+". generaci");
        chart.getXYPlot().setDataset(null);
        chart.getPlot().setBackgroundPaint(Color.WHITE);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        //p.chart = result;
        int idx = p.sliderVal;
        // pro kazdy typ zaznamu, mi dej cetnost zmeny a jeho pdp hodnotu.
        for(SubProblem s : p.subProblems){
            for(Logs logs : s.logs){
                int sum = 0;
                int len = 0;
                for(Log log : logs.log){
                    for(int i = idx; i < log.max.length; i+=p.generationChange, len++)
                        sum += log.max[i];
                }
                if(len != 0)
                    logs.avg = sum / len;
                //System.err.println(logs.avg);
            }
        }
        
        
        List<Tiskni> tiskni = new ArrayList<>();
        for(SubProblem s : p.subProblems){
            for(Logs logs : s.logs){
                boolean ano = true;
                for(Tiskni a : tiskni){
                    if(a.name.equals(logs.name)){
                        //System.err.println(logs.avg);
                        a.hodnoty.add(new Dvojice(s.a, logs.avg));
                        ano = false;
                        break;
                    }
                }
                if(ano){
                    Tiskni novej = new Tiskni(logs.name);
                    novej.hodnoty.add(new Dvojice(s.a, logs.avg));
                    tiskni.add(novej);
                }
            }
        }
        for(Tiskni t : tiskni){
            for(int i = 0; i < t.hodnoty.size(); i++) {
                int tmp = i;
                for(int j = i; j < t.hodnoty.size(); j++){
                    if(t.hodnoty.get(tmp).a < t.hodnoty.get(j).a)
                        tmp = j;
                }
                Dvojice d = t.hodnoty.get(tmp);
                t.hodnoty.set(tmp, t.hodnoty.get(i));
                t.hodnoty.set(i, d);
            }
        }
        
        XYSeriesCollection dataset = new XYSeriesCollection();
        for(Tiskni tisk : tiskni){
            XYSeries data = new XYSeries(tisk.name);
            for(Dvojice d : tisk.hodnoty){
                data.add(d.a, d.b);
            }
            dataset.addSeries(data);
            chart.getXYPlot().setDataset(dataset);
            
        }
        ChartPanel chartPanel = new ChartPanel(chart);
        // default size
        chartPanel.setPreferredSize(new java.awt.Dimension(250, 270));
        chartPanel.revalidate();
        p.chart = chartPanel;
        p.chart.repaint();
    }
    
    public void createChart(Problem p){
        JFreeChart chart = ChartFactory.createXYLineChart(
                "Závislost četnosti změny prostředí na fitness v "+p.sliderVal+". generaci", "Pravděpodobnost změny [%]", "Nejlepší Fitness", null, 
                PlotOrientation.VERTICAL, true, true, false);
        chart.getPlot().setBackgroundPaint(Color.WHITE);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        //p.chart = result;
        int idx = p.sliderVal;
        // pro kazdy typ zaznamu, mi dej cetnost zmeny a jeho pdp hodnotu.
        for(SubProblem s : p.subProblems){
            for(Logs logs : s.logs){
                int sum = 0;
                int len = 0;
                for(Log log : logs.log){
                    for(int i = idx; i < log.max.length; i+=p.generationChange, len++)
                        sum += log.max[i];
                }
                if(len != 0)
                    logs.avg = sum / len;
            }
        }
        
        
        List<Tiskni> tiskni = new ArrayList<>();
        for(SubProblem s : p.subProblems){
            for(Logs logs : s.logs){
                boolean ano = true;
                for(Tiskni a : tiskni){
                    if(a.name.equals(logs.name)){
                        a.hodnoty.add(new Dvojice(s.a, logs.avg));
                        ano = false;
                        break;
                    }
                }
                if(ano){
                    Tiskni novej = new Tiskni(logs.name);
                    novej.hodnoty.add(new Dvojice(s.a, logs.avg));
                    tiskni.add(novej);
                }
            }
        }
        for(Tiskni t : tiskni){
            for(int i = 0; i < t.hodnoty.size(); i++) {
                int tmp = i;
                for(int j = i; j < t.hodnoty.size(); j++){
                    if(t.hodnoty.get(tmp).a < t.hodnoty.get(j).a)
                        tmp = j;
                }
                Dvojice d = t.hodnoty.get(tmp);
                t.hodnoty.set(tmp, t.hodnoty.get(i));
                t.hodnoty.set(i, d);
            }
        }
        
        XYSeriesCollection dataset = new XYSeriesCollection();
        for(Tiskni tisk : tiskni){
            XYSeries data = new XYSeries(tisk.name);
            for(Dvojice d : tisk.hodnoty){
                data.add(d.a, d.b);
            }
            dataset.addSeries(data);
            chart.getXYPlot().setDataset(dataset);
            
        }
        
        ChartPanel chartPanel = new ChartPanel(chart);
        // default size
        chartPanel.setPreferredSize(new java.awt.Dimension(250, 270));
        chartPanel.revalidate();
        chartPanel.repaint();
        p.chart = chartPanel;
        revalidate();
        repaint();
    }
    
    private class Dvojice{
        int a;
        int b;

        public Dvojice(int a, int b) {
            this.a = a;
            this.b = b;
        }
        
    }
    private class Tiskni{
            String name;
            List<Dvojice> hodnoty;

        public Tiskni(String n) {
            name = n;
            hodnoty = new ArrayList<>();
        }
    };
    // ga_best [[][][]] // pro tri behy
    // nga_best
    public void createChart(SubProblem s){
        JFreeChart chart = ChartFactory.createXYLineChart(
                s.name +" změny", "Generace", "Nejlepší Fitness", null, 
                PlotOrientation.VERTICAL, true, true, false);
        chart.getPlot().setBackgroundPaint(Color.WHITE);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        int idx = 0;
        int BIGidx = 0;
        for(Logs l : s.logs){
            XYSeriesCollection dataset = new XYSeriesCollection();
            XYSeriesCollection dataset_avg = new XYSeriesCollection();
            XYSeries avg = new XYSeries(l.name);
            XYSeries min = new XYSeries("a");
            XYSeries max = new XYSeries("b");
            //int[] min = new int[l.log.get(0).max.length];
            //int[] avg = new int[l.log.get(0).max.length];
            //int[] max = new int[l.log.get(0).max.length];
            for(int i = 0; i < l.log.get(0).max.length; i++){
                int sum = 0;
                int maximal = 0;
                int minimal = Integer.MAX_VALUE;
                for(Log log : l.log){
                    sum += log.max[i];
                    if(log.max[i] < minimal){
                        minimal = log.max[i];
                    }
                    if(log.max[i] > maximal){
                        maximal = log.max[i];
                    }
                }
                min.add(i, minimal);
                max.add(i, maximal);
                avg.add(i, sum/l.log.size());
            }
            
            dataset.addSeries(min);
            dataset.addSeries(max);
            dataset_avg.addSeries(avg);
            
            //chart.getXYPlot().getRenderer(idx).setLegendItemLabelGenerator(null);
            
            chart.getXYPlot().setDataset(idx, dataset_avg);
            chart.getXYPlot().setRenderer(idx, new XYLineAndShapeRenderer(true, false));
            Color color = (Color) ((AbstractRenderer) chart.getXYPlot().getRenderer(idx)).lookupSeriesPaint(idx/2);
            Color clr = new Color(color.getRed(), color.getGreen(), color.getBlue(), 42);
            chart.getXYPlot().getRenderer(idx).setSeriesPaint(0, color);
            idx++;
            chart.getXYPlot().setDataset(idx, dataset);
            chart.getXYPlot().setRenderer(idx, new XYDifferenceRenderer(clr, clr, false));
            chart.getXYPlot().getRenderer(idx).setSeriesPaint(0, new Color(0,0,0,0));
            chart.getXYPlot().getRenderer(idx).setSeriesPaint(1, new Color(0,0,0,0));
            chart.getXYPlot().getRenderer(idx).setSeriesVisibleInLegend(0,false);
            chart.getXYPlot().getRenderer(idx).setSeriesVisibleInLegend(1,false);
            idx++;
        }
        ChartPanel chartPanel = new ChartPanel(chart);
        // default size
        chartPanel.setPreferredSize(new java.awt.Dimension(250, 270));
        chartPanel.setName(s.name);
        s.chart = chartPanel;
        s.chart.revalidate();
        s.chart.repaint();
    }
    public void updateChart(SubProblem s){
        JFreeChart tmpChart = ChartFactory.createXYLineChart(
                s.name +" změny", "Generace", "Nejlepší Fitness", null, 
                PlotOrientation.VERTICAL, true, true, false);
        JFreeChart chart = s.chart.getChart();
        chart.getXYPlot().setDataset(null);
        chart.getPlot().setBackgroundPaint(Color.WHITE);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        chart.getXYPlot().setDomainGridlineStroke(new BasicStroke());
        chart.getXYPlot().setDomainGridlinePaint(grid);
        chart.getXYPlot().setRangeGridlineStroke(new BasicStroke());
        chart.getXYPlot().setRangeGridlinePaint(grid);
        int idx = 0;
        int BIGidx = 0;
        for(Logs l : s.logs){
            XYSeriesCollection dataset = new XYSeriesCollection();
            XYSeriesCollection dataset_avg = new XYSeriesCollection();
            XYSeries avg = new XYSeries(l.name);
            XYSeries min = new XYSeries("a");
            XYSeries max = new XYSeries("b");
            //int[] min = new int[l.log.get(0).max.length];
            //int[] avg = new int[l.log.get(0).max.length];
            //int[] max = new int[l.log.get(0).max.length];
            for(int i = 0; i < l.log.get(0).max.length; i++){
                int sum = 0;
                int maximal = 0;
                int minimal = Integer.MAX_VALUE;
                for(Log log : l.log){
                    sum += log.max[i];
                    if(log.max[i] < minimal){
                        minimal = log.max[i];
                    }
                    if(log.max[i] > maximal){
                        maximal = log.max[i];
                    }
                }
                min.add(i, minimal);
                max.add(i, maximal);
                avg.add(i, sum/l.log.size());
            }
            
            dataset.addSeries(min);
            dataset.addSeries(max);
            dataset_avg.addSeries(avg);
            
            //chart.getXYPlot().getRenderer(idx).setLegendItemLabelGenerator(null);
            
            tmpChart.getXYPlot().setDataset(idx, dataset_avg);
            tmpChart.getXYPlot().setRenderer(idx, new XYLineAndShapeRenderer(true, false));
            
            chart.getXYPlot().setDataset(idx, dataset_avg);
            chart.getXYPlot().setRenderer(idx, new XYLineAndShapeRenderer(true, false));
            Color color = (Color) ((AbstractRenderer) tmpChart.getXYPlot().getRenderer(idx)).lookupSeriesPaint(idx/2);
            //Color color = (Color) ((AbstractRenderer) chart.getXYPlot().getRenderer(idx)).lookupSeriesPaint(idx/2);
            Color clr = new Color(color.getRed(), color.getGreen(), color.getBlue(), 20);
            chart.getXYPlot().getRenderer(idx).setSeriesPaint(0, color);
            idx++;
            chart.getXYPlot().setDataset(idx, dataset);
            chart.getXYPlot().setRenderer(idx, new XYDifferenceRenderer(clr, clr, false));
            chart.getXYPlot().getRenderer(idx).setSeriesPaint(0, new Color(0,0,0,0));
            chart.getXYPlot().getRenderer(idx).setSeriesPaint(1, new Color(0,0,0,0));
            chart.getXYPlot().getRenderer(idx).setSeriesVisibleInLegend(0,false);
            chart.getXYPlot().getRenderer(idx).setSeriesVisibleInLegend(1,false);
            idx++;
        }
        ChartPanel chartPanel = new ChartPanel(chart);
        // default size
        chartPanel.setPreferredSize(new java.awt.Dimension(250, 270));
        chartPanel.setName(s.name);
        s.chart = chartPanel;
        s.chart.revalidate();
        s.chart.repaint();
     }    
    // Whose function is this? 
    // This is method baby.
    // Whose method is this?
    // Zed's.
    // Who is Zed?
    // Zed is dead, baby. Zed is dead. 
    @Override
    public void plotMe(String c, String a, String b, int[] min, int[] avg, int[] max, int gen){
        //System.out.println(a);
        //System.out.println(b);
        //System.out.println(c);
        for (Problem p : problems){
            if( a.equals(p.name)){
                for (SubProblem s : p.subProblems){
                    if( b.equals(s.name)){
                        for(Logs l : s.logs) {
                            if(c.equals(l.name)){
                                l.log.add(new Log(min, avg, max));
                                updateChart(s);
                                if(p.generationChange != 0)
                                    updateChart(p);
                                return;
                            } 
                        }
                        Logs logs = new Logs(c);
                        logs.log.add(new Log(min, avg, max));
                        s.logs.add(logs);
                        updateChart(s);
                        if(p.generationChange != 0)
                            updateChart(p);
                        return;
                    }
                }
                SubProblem subProblem = new SubProblem(b);
                Logs logs = new Logs(c);
                logs.log.add(new Log(min, avg, max));
                subProblem.logs.add(logs);
                p.subProblems.add(subProblem);
                createChart(subProblem);
                p.tabs.add(subProblem.chart);
                JButton butt = new JButton();
                butt.addActionListener(new DelChart(subProblem, p, this.problems, jTabbedPane1));
                subProblem.chart.setLayout(new FlowLayout(FlowLayout.RIGHT));
                butt.setText("Smazat vše");
                subProblem.chart.add(butt);
                if(p.generationChange != 0)
                    updateChart(p);
                return;
            }
        }
        Problem officer = new Problem(a, gen);
        SubProblem subProblem = new SubProblem(b);
        Logs logs = new Logs(c);
        logs.log.add(new Log(min, avg, max));
        subProblem.logs.add(logs);
        createChart(subProblem);
        officer.subProblems.add(subProblem);
        problems.add(officer);
        JPanel p = new JPanel();
        p.setName(a);
        jTabbedPane1.add(p);
        p.setLayout(new java.awt.GridLayout(1,0));
        JTabbedPane tmp = new JTabbedPane();
        officer.panel = p;
        officer.tabs = tmp;
        p.add(tmp);
        tmp.add(subProblem.chart);
        if(officer.generationChange != 0){
            createChart(officer);
            officer.chart.setName("Graf četnosti změn");
            JSlider slide = new JSlider(0, officer.generationChange, officer.sliderVal);
            slide.addChangeListener(new SlideChanged(slide, officer));
            officer.chart.setLayout(new FlowLayout(FlowLayout.RIGHT));
            officer.chart.add(slide);
            tmp.add(officer.chart);
        }
        JButton butt = new JButton();
        butt.addActionListener(new DelChart(subProblem, officer, this.problems, jTabbedPane1));
        butt.setText("Smazat vše");
        subProblem.chart.setLayout(new FlowLayout(FlowLayout.RIGHT));
        subProblem.chart.add(butt);
        
    }
    private class SlideChanged implements javax.swing.event.ChangeListener{
        JSlider s; 
        Problem p;
        public SlideChanged(JSlider s, Problem p) {
            this.s = s;
            this.p = p;
        }
        
        @Override
        public void stateChanged(ChangeEvent ce) {
            p.sliderVal = s.getValue();
            updateChart(p);
            
        }
    }
    private class DelChart implements java.awt.event.ActionListener{
        SubProblem s;
        Problem p;
        List<Problem> l;
        JTabbedPane maintab;
        public DelChart(SubProblem s, Problem p, List<Problem> l, JTabbedPane m) {
            this.s = s;
            this.p = p;
            this.l = l;
            this.maintab = m;
        }

        @Override
        public void actionPerformed(ActionEvent ae) {
            p.tabs.remove(p.tabs.getSelectedComponent());
            if(p.tabs.getTabCount() <= 1){
                l.remove(p);
                maintab.remove(p.panel);
            }
            s.chart = null;
        }
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
        java.awt.GridBagConstraints gridBagConstraints;

        buttonGroup1 = new javax.swing.ButtonGroup();
        jLabel1 = new javax.swing.JLabel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        textovyVystup = new javax.swing.JTextArea();
        jButton2 = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jLabel13 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        fKardinalita = new javax.swing.JTextField();
        fTypGA = new javax.swing.JComboBox();
        fCetnostZmen = new javax.swing.JTextField();
        fProstredi = new javax.swing.JTextField();
        fGenerace = new javax.swing.JTextField();
        fFitness = new javax.swing.JComboBox();
        jLabel16 = new javax.swing.JLabel();
        fChrom = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        fPopulace = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        fSelekcePop = new javax.swing.JComboBox();
        jLabel5 = new javax.swing.JLabel();
        fPotomci = new javax.swing.JTextField();
        jLabel10 = new javax.swing.JLabel();
        fSelekceRodice = new javax.swing.JComboBox();
        jLabel6 = new javax.swing.JLabel();
        fMutace = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        fKrizeni = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        fBoduKrizeni = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        fTypZmen = new javax.swing.JComboBox();
        fStrategy = new javax.swing.JComboBox();
        jLabel17 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jProgressBar1 = new javax.swing.JProgressBar();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabel1.setFont(new java.awt.Font("Tahoma", 1, 18)); // NOI18N
        jLabel1.setText("Diploidní genetický algoritmus");

        jTabbedPane1.setToolTipText("");
        jTabbedPane1.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        textovyVystup.setEditable(false);
        textovyVystup.setColumns(20);
        textovyVystup.setFont(new java.awt.Font("Monospaced", 0, 12)); // NOI18N
        textovyVystup.setLineWrap(true);
        textovyVystup.setRows(5);
        textovyVystup.setWrapStyleWord(true);
        jScrollPane2.setViewportView(textovyVystup);

        jButton2.setText("Vzmazat log");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 473, Short.MAX_VALUE)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton2)
                .addContainerGap())
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 346, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jButton2)
                .addGap(6, 6, 6))
        );

        jTabbedPane1.addTab("Textový výstup", jPanel4);

        jPanel5.setAlignmentX(0.0F);
        jPanel5.setAlignmentY(0.0F);
        jPanel5.setLayout(new java.awt.GridBagLayout());

        jLabel13.setText("Četnost změn:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel13, gridBagConstraints);

        jLabel12.setText("Změna prostředí:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel12, gridBagConstraints);

        jLabel3.setText("Počet generací:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel3, gridBagConstraints);

        jLabel11.setText("Fitness funkce:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel11, gridBagConstraints);

        jLabel15.setText("DDDGA/NDDGA/GA:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel15, gridBagConstraints);

        jLabel14.setText("Kardinalita dominance:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel14, gridBagConstraints);

        fKardinalita.setText("3");
        fKardinalita.setMinimumSize(new java.awt.Dimension(60, 20));
        fKardinalita.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 6;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fKardinalita, gridBagConstraints);

        fTypGA.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Deterministická dominance", "Nedeterministická dominance", "Klasický GA" }));
        fTypGA.setMinimumSize(new java.awt.Dimension(60, 20));
        fTypGA.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 5;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fTypGA, gridBagConstraints);

        fCetnostZmen.setText("0.1");
        fCetnostZmen.setMinimumSize(new java.awt.Dimension(60, 20));
        fCetnostZmen.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 3;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fCetnostZmen, gridBagConstraints);

        fProstredi.setText("50");
        fProstredi.setMinimumSize(new java.awt.Dimension(60, 20));
        fProstredi.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 2;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fProstredi, gridBagConstraints);

        fGenerace.setText("500");
        fGenerace.setMinimumSize(new java.awt.Dimension(60, 20));
        fGenerace.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 1;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fGenerace, gridBagConstraints);

        fFitness.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "One Max", "Royal road", "Deceptive Royal" }));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 7;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fFitness, gridBagConstraints);

        jLabel16.setText("Délka chromozomu:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel16, gridBagConstraints);

        fChrom.setText("100");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 8;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fChrom, gridBagConstraints);

        jLabel4.setText("Velikost populace:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel4, gridBagConstraints);

        fPopulace.setText("100");
        fPopulace.setMinimumSize(new java.awt.Dimension(60, 20));
        fPopulace.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 9;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fPopulace, gridBagConstraints);

        jLabel9.setText("Selekce nové pop:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel9, gridBagConstraints);

        fSelekcePop.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Turnaj", "Ruleta", "Náhodně", "Deterministicky" }));
        fSelekcePop.setSelectedIndex(3);
        fSelekcePop.setMinimumSize(new java.awt.Dimension(60, 20));
        fSelekcePop.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 10;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fSelekcePop, gridBagConstraints);

        jLabel5.setText("Počet potomků:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel5, gridBagConstraints);

        fPotomci.setText("100");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 11;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fPotomci, gridBagConstraints);

        jLabel10.setText("Výběr rodičů:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 12;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel10, gridBagConstraints);

        fSelekceRodice.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Turnaj", "Ruleta", "Náhodně" }));
        fSelekceRodice.setMinimumSize(new java.awt.Dimension(60, 20));
        fSelekceRodice.setPreferredSize(new java.awt.Dimension(60, 20));
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 12;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fSelekceRodice, gridBagConstraints);

        jLabel6.setText("Pravděpod. mutace:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel6, gridBagConstraints);

        fMutace.setText("0.01");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 14;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fMutace, gridBagConstraints);

        jLabel7.setText("Pravděpod. křížení:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel7, gridBagConstraints);

        fKrizeni.setText("0.1");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 15;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fKrizeni, gridBagConstraints);

        jLabel8.setText("Max. počet bodů křížení:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 16;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel8, gridBagConstraints);

        fBoduKrizeni.setText("1");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 16;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHWEST;
        jPanel5.add(fBoduKrizeni, gridBagConstraints);

        jLabel2.setText("Typ změn:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel2, gridBagConstraints);

        fTypZmen.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Náhodně", "Periodicky" }));
        fTypZmen.setSelectedIndex(1);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 4;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        gridBagConstraints.ipadx = 100;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.NORTHEAST;
        jPanel5.add(fTypZmen, gridBagConstraints);

        fStrategy.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "S rodiči (n+m)", "Bez rodičů (n; m)" }));
        fStrategy.setSelectedIndex(1);
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 1;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.fill = java.awt.GridBagConstraints.BOTH;
        jPanel5.add(fStrategy, gridBagConstraints);

        jLabel17.setText("Stretegie:");
        gridBagConstraints = new java.awt.GridBagConstraints();
        gridBagConstraints.gridx = 0;
        gridBagConstraints.gridy = 13;
        gridBagConstraints.anchor = java.awt.GridBagConstraints.WEST;
        jPanel5.add(jLabel17, gridBagConstraints);

        jButton1.setText("Spustit");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel1)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGap(147, 147, 147)
                                .addComponent(jButton1)
                                .addGap(177, 177, 177))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jProgressBar1, javax.swing.GroupLayout.PREFERRED_SIZE, 369, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 369, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                        .addComponent(jTabbedPane1)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTabbedPane1)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 344, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jProgressBar1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    @Override
    public void print(){
        print("");
    }
                        
    @Override
    public void print(String s){
        log += s+"\n";
        textovyVystup.setText(log);
    }
    @Override
    public void setBar(int val){
        jProgressBar1.setString("Filling progress bar "+val+"%");
        jProgressBar1.setValue(val);
    }
    private void debug(){
        print("===========DEBUG===========");
        print("Změna prostředí:    "+ fProstredi.getText() + " generací");
        print("Četnost změn:       "+ (Double.valueOf(fCetnostZmen.getText()) * 100.0) + "%");
        print("Délka chromozomu:   "+ fChrom.getText());
        print("Typ fitness:        "+ fFitness.getSelectedItem());
        print("Počet generací:     "+ fGenerace.getText());
        print("Kardinalita:        "+ fKardinalita.getText());
        print("Pdp. křížení:       "+ (Double.valueOf(fKrizeni.getText()) * 100.0)+"%");
        print("Počet bodů křížení: "+ fBoduKrizeni.getText());
        print("Pdp. mutace:        "+ (Double.valueOf(fMutace.getText())*100.0)+"%");
        print("Velikost populace:  "+ fPopulace.getText());
        print("Počet potomků:      "+ fPotomci.getText());
        print("Typ selekce pop:    "+ fSelekcePop.getSelectedItem());
        print("Typ selekce rodice: "+ fSelekceRodice.getSelectedItem());
        print("Typ algoritmu:      "+ fTypGA.getSelectedItem());
        print("===========================");
        print();
    }
    
    
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        debug();
        switch (fFitness.getSelectedItem().toString()) {
            case "One Max":
                fitnessType = new OneMax();
                break;
            case "Royal road": // pulp fiction
                fitnessType = new RoyalRoad();
                break;
            default:
                fitnessType = new Depicitve();
                break;
        }
        
        switch (fSelekcePop.getSelectedItem().toString()) {
            case "Turnaj":
                selectTypePopulation = new Turnaj();
                break;
            case "Ruleta":
                selectTypePopulation = new Ruleta();
                break;
            case "Deterministicky":
                selectTypePopulation = new Deterministic();
                break;
            default:
                selectTypePopulation = new Nahoda();
                break;
        }
        
        switch (fSelekceRodice.getSelectedItem().toString()) {
            case "Turnaj":
                selectTypeParent = new Turnaj();
                break;
            case "Ruleta":
                selectTypeParent = new Ruleta();
                break;
            default:
                selectTypeParent = new Nahoda();
                break;
        }
        changeEnviromentType = fTypZmen.getSelectedIndex();
        maxGenerations = Integer.valueOf(fGenerace.getText());
        changeEnviromentGenerations = Integer.valueOf(fProstredi.getText());
        changeEnviromentProbability = Double.valueOf(fCetnostZmen.getText());
        cardinality = Integer.valueOf(fKardinalita.getText());
        chromosomeLength = Integer.valueOf(fChrom.getText());
        population = Integer.valueOf(fPopulace.getText());
        offsprings = Integer.valueOf(fPotomci.getText());
        probabilityMutation = Double.valueOf(fMutace.getText());
        probabilityCrossover = Double.valueOf(fKrizeni.getText());
        crossoverPoints = Integer.valueOf(fBoduKrizeni.getText());
        strategy1plus1 = (fStrategy.getSelectedIndex() == 0) ? false : true;
        strGAType = fTypGA.getSelectedItem().toString();
        ///this);
        
        
        Chromosome nobody = new Chromosome();
        nobody.init();
        nobody.mutate();
        
        //FuckingJava ga = new FuckingJava();
        switch (fTypGA.getSelectedItem().toString()) {
            case "Deterministická dominance":
                if(cardinality <= 2){
                    JOptionPane.showMessageDialog(this,
                        "Pro DGA musí být kardinalita větší než 2.",
                        "Inane error",
                        JOptionPane.ERROR_MESSAGE);
                    break;
                }
                DGA dga = new DGA(this);
                dga.start();
                break;
            case "Klasický GA":
                cardinality = 2;
                GA ga = new GA(this);
                ga.start();
                break;
            case "Nedeterministická dominance":
                if((cardinality % 2) == 1 || cardinality <= 2){
                    JOptionPane.showMessageDialog(this,
                        "Pro NGA musí být kardinalita sudá a větší než 2.",
                        "Inane error",
                        JOptionPane.ERROR_MESSAGE);
                    break;
                }
                NGA nga = new NGA(this);
                nga.start();
                break;
            default:
                break;
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        log = "";
        textovyVystup.setText(log);
    }//GEN-LAST:event_jButton2ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                //System.err.println(info.getName());
                if ("Windows".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(MainForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(MainForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(MainForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(MainForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new MainForm().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JTextField fBoduKrizeni;
    private javax.swing.JTextField fCetnostZmen;
    private javax.swing.JTextField fChrom;
    private javax.swing.JComboBox fFitness;
    private javax.swing.JTextField fGenerace;
    private javax.swing.JTextField fKardinalita;
    private javax.swing.JTextField fKrizeni;
    private javax.swing.JTextField fMutace;
    private javax.swing.JTextField fPopulace;
    private javax.swing.JTextField fPotomci;
    private javax.swing.JTextField fProstredi;
    private javax.swing.JComboBox fSelekcePop;
    private javax.swing.JComboBox fSelekceRodice;
    private javax.swing.JComboBox fStrategy;
    private javax.swing.JComboBox fTypGA;
    private javax.swing.JComboBox fTypZmen;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JProgressBar jProgressBar1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTextArea textovyVystup;
    // End of variables declaration//GEN-END:variables
}

class Problem{
    JPanel panel;
    JTabbedPane tabs;
    String name;
    ChartPanel chart;
    int generationChange;
    int sliderVal;
    List<SubProblem> subProblems;
    public Problem(String name, int generation) {
        this.generationChange = generation-1;
        this.sliderVal = generation-1;
        this.name = name;
        this.subProblems = new ArrayList<>();
    }
    
}
class SubProblem{
    String name;
    int a;
    ChartPanel chart;
    List<Logs> logs;
    public SubProblem(String name){
        this.name = name;
        a = Integer.valueOf(name.replace('%', '0'))/10; // that hack
        this.logs = new ArrayList<>();
    }
}
class Logs{
    String name;
    List<Log> log;
    int avg;
    Logs(String name){
        this.name = name;
        this.log = new ArrayList<>();
    }
}
class Log{
    int[] min;
    int[] avg;
    int[] max;
    Log(int[]a,int[]b,int[]c){
        min = a;
        avg = b;
        max = c;
    }
}
interface SendMsg {
    void print();
    void print(String a);
    void setBar(int val);
    void plotMe(String a, String b, String c, int[] min, int[] avg, int[] max, int gen);
}